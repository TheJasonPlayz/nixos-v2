#!/usr/bin/env python

from subprocess import run, PIPE, DEVNULL
from pathlib import Path
from sys import argv
from os import environ
from utils import *
from ssh_privkey import __main__ as privkey
from latest_xmage import __main__ as xmage

REBUILD_DIR=Path('/etc/nixos/')
PWD=Path.cwd()
SCRIPT_DIR=PWD/'scripts'
AUTOCOMMIT_MESSAGE="\'Auto-commit update\'"
GIT_PRE="git pull; git add -A;"
GIT_POST=f"git commit -m {AUTOCOMMIT_MESSAGE}; git push;"
GIT_FUNC = lambda cmds: get_output(run(cmds, stderr=PIPE, stdout=PIPE, shell=True))
SUDO_PASSWORD=get_sops()["sudo"]

def git_pre():
    return GIT_FUNC(GIT_PRE)

def git_post():
    return GIT_FUNC(GIT_POST)


def rsync_func(dir1: str, dir2: str) -> None:
    cmds = f"echo {SUDO_PASSWORD} | sudo -S rsync -ru --exclude=Scripts/ --delete {dir1} {dir2}"
    return get_stderr(run(split_args(cmds), stdout=DEVNULL, stderr=PIPE, shell=True))

def rebuild_func(other_flags: list[str]) -> CompletedProcess:
    cmds = f"echo {SUDO_PASSWORD} | sudo -S sudo nixos-rebuild switch --flake /etc/nixos {" ".join(other_flags)}"
    return run(split_args(cmds), stdout=PIPE, stderr=PIPE, shell=True)

def __main__():
    xmage()
    privkey()

    git_password = get_sops()["github"]["pac"]
    environ["GIT_USERNAME"] = "TheJasonPlayz"
    environ["GIT_PASSWORD"] = git_password

    gitpre_output = git_pre()

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
                rebuild_output = get_output(rebuild_func(argv))
            case "jasonw-laptop":
                rebuild_output = get_output(rebuild_func(argv))
            case "jasonw-server1":
                rebuild_output = get_output(rebuild_func(argv))
            case _:
                raise TypeError("HOSTNAME NOT FOUND")

    gitpost_output = git_post()

    print("=== GIT PRE ===", gitpre_output + "\n", sep="\n")
    print("=== REBUILD ===", rebuild_output + "\n", sep="\n")
    print("=== GIT POST ===", gitpost_output + "\n", sep="\n")
    
__main__()