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
RSYNC = lambda dir1, dir2: run_with_realtime(f"echo {SUDO_PASSWORD} | sudo -S rsync -ru --exclude=scripts/ --delete {dir1} {dir2}")
GIT_PRE="git pull; git add -A;"
GIT_POST=f"git commit -m {AUTOCOMMIT_MESSAGE}; git push;"
SUDO_PASSWORD=get_sops()["sudo"]

def __main__():
    xmage()
    privkey()

    print("=== GIT PRE ===\n")
    run_with_realtime(GIT_PRE)
    print("\n")

    hostname = get_stdout(run(["hostnamectl", "hostname"], stdout=PIPE))
    direction = input(f"To OR From {str(REBUILD_DIR)}?\n(*). To {str(REBUILD_DIR)}\n(1). From {str(REBUILD_DIR)}`\n")
    switch_bool = input("Switch?\n(*). Yes\n(N/n). No\n").lower()

    if direction == "1":
        RSYNC(str(REBUILD_DIR) + "/", str(PWD))
    else:
        RSYNC(str(PWD) + "/", str(REBUILD_DIR))
    
    git_password = get_sops()["github"]["pac"]
    run(split_args(f"git config credential.https://github.com.username {GIT_USERNAME}"))
    environ["GIT_PASSWORD"] = git_password
    environ["GIT_ASKPASS"] = str(Path("./scripts/git_password.sh").absolute())

    print("=== GIT POST ===\n")
    run_with_realtime(GIT_POST)
    print("\n")

__main__()