{ pkgs, username, ... }:

let
  ssh_privkey = ( pkgs.callPackage ./custom/ssh_privkey.nix { inherit username; });
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