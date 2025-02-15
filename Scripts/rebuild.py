#!/usr/bin/env python

from subprocess import run, PIPE, DEVNULL
from pathlib import Path
from sys import argv
from git import Repo, Actor
from os import environ
from utils import *

REBUILD_DIR=Path('/etc/nixos/')
PWD=Path.cwd()
SCRIPT_DIR=PWD/'scripts'
AUTOCOMMIT_MESSAGE="Auto-commit update"
REPO=Repo(str(PWD))
AUTHOR=Actor("Jason D Whitman", "jasondwhitman1124@gmail.com")
SUDO_PASSWORD=get_sops()["sudo"]

def git_pre(repo: Repo):
    repo.remote().pull(progress=GitProgress())
    output = get_output(run(split_args("git add -A"), stderr=PIPE, stdout=PIPE))
    return output

def git_post(repo: Repo):
    repo.git.commit(f"-m {AUTOCOMMIT_MESSAGE}", author=AUTHOR)
    repo.remote().push(progress=GitProgress())

def rsync_func(dir1: str, dir2: str) -> None:
    cmds = f"echo {SUDO_PASSWORD} | sudo -S rsync -ru --exclude=Scripts/ --delete {dir1} {dir2}"
    return get_stderr(run(split_args(cmds), stdout=DEVNULL, stderr=PIPE, shell=True))

def rebuild_func(hostname: str, other_flags: list[str]) -> CompletedProcess:
    cmds = f"echo {SUDO_PASSWORD} | sudo -S sudo nixos-rebuild switch --flake {" ".join(other_flags)} /etc/nixos#{hostname}"
    return run(split_args(cmds), stdout=PIPE, stderr=PIPE, shell=True)

def __main__():
    git_password = get_sops()["github"]["pac"]
    environ["GIT_USERNAME"] = "TheJasonPlayz"
    environ["GIT_PASSWORD"] = git_password

    gitpre_output = git_pre(REPO)

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

    print("=== GIT PRE ===", gitpre_output)
    print("=== REBUILD ===", rebuild_output)
    
__main__()