from subprocess import CompletedProcess, PIPE, run, Popen
from yaml import safe_load

def run_with_realtime(cmds: str, shell: bool):
    process = Popen(
        (split_args(cmds) if not shell else cmds),
        stdout=PIPE,
        stderr=PIPE,
        shell=shell
    )
    while True:
        line = process.stdout.readline()
        if not line and process.poll() is not None:
            break
        print(line.decode(), end='')

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
