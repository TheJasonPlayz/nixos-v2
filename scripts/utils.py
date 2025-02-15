from subprocess import CompletedProcess, PIPE, run
from tqdm import tqdm
from yaml import safe_load

def split_args(cmds: str) -> list[str]:
    return cmds.split(" ")

def get_stdout(proc: CompletedProcess) -> str:
    return proc.stdout.strip().decode("utf-8")

def get_stderr(proc: CompletedProcess) -> str:
    return proc.stderr.strip().decode("utf-8")

def get_output(proc: CompletedProcess) -> str:
    return get_stdout(proc) + "\n" + get_stderr(proc)

def get_sops():
    sops_yaml = get_stdout(run(["sops", "-d", "./secrets.yaml"], stdout=PIPE))
    return safe_load(sops_yaml)
