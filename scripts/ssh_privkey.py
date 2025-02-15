#!/usr/bin/env python

from utils import *
from pathlib import Path
from re import sub, compile, M

OVERLAY = Path("./config/pkgs/custom/ssh_privkey.nix")
PATTERN = compile(r'(\s{2}private_key\s=\spkgs\.writeText\s\"id_ed25519\"\s\'\')(.*)(\'\')')
priv_key = get_sops()["ssh"]["priv_key"]

def __main__():
        with open(OVERLAY) as i:        
                input = i.read()       
                with open(OVERLAY, "w") as o:
                        o.write(sub(PATTERN, rf"\1{priv_key}\3", input, M))