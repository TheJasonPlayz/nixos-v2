from subprocess import CompletedProcess, PIPE, run, Popen
from yaml import safe_load

def run_with_realtime(cmds: str):
    process = Popen(
        cmds,
        stdout=PIPE,
        stderr=PIPE,
        shell=True
    )
    while True:
        stdout_line = process.stdout.readline().decode("utf-8")
        stderr_line = process.stderr.readline().decode("utf-8")
        print(process.poll())
        if not stderr_line and not stdout_line and process.poll() is not None:
            break
        print(stdout_line, stderr_line, end='', sep="\n")

def split_args(cmds: str) -> list[str]:
    return cmds.split(" ")

def get_stdout(proc: CompletedProcess) -> str:
    return proc.stdout.strip().decode("utf-8")

def get_sops():
    sops_yaml = get_stdout(run(["sops", "-d", "./secrets.yaml"], stdout=PIPE))
    return safe_load(sops_yaml)
