from subprocess import run, PIPE, DEVNULL, CompletedProcess
from pathlib import Path
from sys import argv

REBUILD_DIR=Path('/etc/nixos/')
PWD=Path.cwd()
SCRIPT_DIR=PWD/'scripts'
AUTOCOMMIT_MESSAGE="Auto-commit update"
GIT_PRE="git pull; git add -A"
GIT_POST=f"git commit -m {AUTOCOMMIT_MESSAGE}; git push;"

def split_args(cmds: str) -> list[str]:
    return cmds.split(" ")

def get_stdout(proc: CompletedProcess) -> str:
    return proc.stdout.strip().decode("utf-8")

def get_stderr(proc: CompletedProcess) -> str:
    return proc.stderr.strip().decode("utf-8")

def get_output(proc: CompletedProcess) -> str:
    return get_stdout(proc) + get_stderr(proc)

def rsync_func(dir1: str, dir2: str) -> None:
    cmds = f"rsync -ru --exclude=Scripts/ --delete {dir1} {dir2}"
    run(split_args(cmds), stdout=DEVNULL, shell=True)

def rebuild_func(hostname: str, other_flags: list[str]) -> CompletedProcess:
    cmds = f"nixos-rebuild switch --flake {" ".join(other_flags)} /etc/nixos#{hostname}"
    return run(split_args(cmds), stdout=PIPE, stderr=PIPE, shell=True)

def __main__():
    gitpre_output = get_output(run(GIT_PRE, stdout=PIPE, stderr=PIPE, shell=True))

    hostname = get_stdout(run(["hostnamectl", "hostname"], stdout=PIPE))
    direction = input(f"To OR From {REBUILD_DIR}?\n(*). To {REBUILD_DIR}\n(1). From {REBUILD_DIR}\n")
    switch_bool = input("Switch?\n(*). Yes\n(N/n). No\n").lower()

    if direction == "1":
        rsync_func(REBUILD_DIR, PWD)
    else:
        rsync_func(PWD, REBUILD_DIR)
    
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

    gitpost_output = get_output(run(GIT_POST, stdout=PIPE, stderr=PIPE, shell=True))

    print("=== GIT PRE ===", gitpre_output, sep="\n")
    print("=== REBUILD ===", rebuild_output, sep="\n")
    print("=== GIT POST ===", gitpost_output, sep="\n")
    
__main__()