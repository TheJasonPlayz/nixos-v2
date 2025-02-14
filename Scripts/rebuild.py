from subprocess import run, PIPE, DEVNULL, CompletedProcess
from pathlib import Path
from sys import argv
from git import Repo, RemoteProgress, Actor
from tqdm import tqdm
from yaml import safe_load

REBUILD_DIR=Path('/etc/nixos/')
PWD=Path.cwd()
SCRIPT_DIR=PWD/'scripts'
AUTOCOMMIT_MESSAGE="Auto-commit update"
GIT_PRE="git pull; git add -A"
GIT_POST=f"git commit -m {AUTOCOMMIT_MESSAGE}; git push;"
REPO=Repo(str(PWD))
AUTHOR=Actor("Jason D Whitman", "jasondwhitman1124@gmail.com")

class Progress(RemoteProgress):
    def __init__(self):
        super().__init__()
        self.pbar = tqdm()
    def update(self, op_code, cur_count, max_count=None, message = ''):
        self.pbar.total = max_count
        self.pbar.n = cur_count
        self.pbar.refresh()

def split_args(cmds: str) -> list[str]:
    return cmds.split(" ")

def get_stdout(proc: CompletedProcess) -> str:
    return proc.stdout.strip().decode("utf-8")

def get_stderr(proc: CompletedProcess) -> str:
    return proc.stderr.strip().decode("utf-8")

def get_output(proc: CompletedProcess) -> str:
    return get_stdout(proc) + get_stderr(proc)

def git_pre(repo: Repo):
    repo.remote().pull(progress=Progress())
    repo.git.add('-A')

def git_post(repo: Repo):
    repo.index.commit(f"-m {AUTOCOMMIT_MESSAGE}", author=AUTHOR)
    repo.remote().push(progress=Progress())

def rsync_func(dir1: str, dir2: str) -> None:
    cmds = f"rsync -ru --exclude=Scripts/ --delete {dir1} {dir2}"
    run(split_args(cmds), stdout=DEVNULL)

def rebuild_func(hostname: str, other_flags: list[str]) -> CompletedProcess:
    cmds = f"nixos-rebuild switch --flake {" ".join(other_flags)} /etc/nixos#{hostname}"
    return run(split_args(cmds), stdout=PIPE, stderr=PIPE)

def __main__():
    git_pre(REPO)

    password = get_stdout(run(["sops", "./secrets.yaml"], stdout=PIPE))
    hostname = get_stdout(run(["hostnamectl", "hostname"], stdout=PIPE))
    direction = input(f"To OR From {str(REBUILD_DIR)}?\n(*). To {str(REBUILD_DIR)}\n(1). From {str(REBUILD_DIR)}`\n")
    switch_bool = input("Switch?\n(*). Yes\n(N/n). No\n").lower()

    if direction == "1":
        rsync_func(str(REBUILD_DIR), str(PWD))
    else:
        rsync_func(str(PWD), str(REBUILD_DIR))
    
    rebuild_output = ""
    if switch_bool != "n":
        match hostname:
            case "jasonw-pc":
                rebuild_output = get_output(rebuild_func("pc", argv))
            case "jasonw-laptop":
                rebuild_output = get_output(rebuild_func("laptop", argv))
            case "jasonw-server1":
                rebuild_output = get_output(rebuild_func("server1", argv))
            case _:
                raise TypeError("HOSTNAME NOT FOUND")

    git_post(REPO)

    print("=== REBUILD ===", rebuild_output, sep="\n")
    print(password)
__main__()