from subprocess import CompletedProcess, PIPE, run
from git import RemoteProgress
from tqdm import tqdm
from yaml import safe_load

def split_args(cmds: str) -> list[str]:
    return cmds.split(" ")

def get_stdout(proc: CompletedProcess) -> str:
    return proc.stdout.strip().decode("utf-8")

def get_stderr(proc: CompletedProcess) -> str:
    return proc.stderr.strip().decode("utf-8")

def get_output(proc: CompletedProcess) -> str:
    return get_stdout(proc) + get_stderr(proc)

def get_sops():
    sops_yaml = get_stdout(run(["sops", "-d", "./secrets.yaml"], stdout=PIPE))
    return safe_load(sops_yaml)

class GitProgress(RemoteProgress):
    def __init__(self):
        super().__init__()
        self.pbar = tqdm()
    def update(self, op_code, cur_count, max_count=None, message = ''):
        self.pbar.total = max_count
        self.pbar.n = cur_count
        self.pbar.refresh()