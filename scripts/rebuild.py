#!/usr/bin/env python

from subprocess import run, PIPE, DEVNULL
from pathlib import Path
from sys import argv
from os import environ
from utils import *
from ssh_privkey import __main__ as privkey
from latest_xmage import __main__ as xmage

REBUILD_DIR=Path('/etc/nixos')
PWD=Path.cwd()
SCRIPT_DIR=PWD/'scripts'
AUTOCOMMIT_MESSAGE="\'Auto-commit update\'"
GIT_USERNAME="TheJasonPlayz"
GIT_PRE="git pull; git add -A;"
GIT_POST=f"git commit -m {AUTOCOMMIT_MESSAGE}; git push;"
GIT_FUNC = lambda cmds: get_output(run(cmds, stderr=PIPE, stdout=PIPE, shell=True))
SUDO_PASSWORD=get_sops()["sudo"]

def git_pre():
    return GIT_FUNC(GIT_PRE)

def git_post():
    return GIT_FUNC(GIT_POST)


def rsync_func(dir1: str, dir2: str):
    cmds = f"echo {SUDO_PASSWORD} | sudo -S rsync -ru --exclude=Scripts/ --delete {dir1} {dir2}"
    run_with_realtime(cmds, True)

def rebuild_func(other_flags: list[str]):
    cmds = f"echo {SUDO_PASSWORD} | sudo -S nixos-rebuild switch --flake /etc/nixos {" ".join(other_flags)}"
    run_with_realtime(cmds, True)

def __main__():
    xmage()
    privkey()

    print("=== GIT PRE ===", git_pre() + "\n", sep="\n")

    hostname = get_stdout(run(["hostnamectl", "hostname"], stdout=PIPE))
    direction = input(f"To OR From {str(REBUILD_DIR)}?\n(*). To {str(REBUILD_DIR)}\n(1). From {str(REBUILD_DIR)}`\n")
    switch_bool = input("Switch?\n(*). Yes\n(N/n). No\n").lower()

    if direction == "1":
        rsync_func(str(REBUILD_DIR) + "/", str(PWD))
    else:
        rsync_func(str(PWD) + "/", str(REBUILD_DIR))
    
    rebuild_func(argv[1:])

    git_password = get_sops()["github"]["pac"]
    run(split_args(f"git config credential.https://github.com.username {GIT_USERNAME}"))
    environ["GIT_PASSWORD"] = git_password
    environ["GIT_ASKPASS"] = str(Path("./scripts/git_password.sh").absolute())

    print("=== GIT POST ===", git_post() + "\n", sep="\n")

__main__()