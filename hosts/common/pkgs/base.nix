{ pkgs, ... }:

let
  ssh_privkey = ( pkgs.callPackage ./custom/ssh_privkey.nix { });
in
{
  environment.systemPackages = with pkgs; [
    ssh_privkey
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}