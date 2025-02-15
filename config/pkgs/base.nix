{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ./custom/ssh_privkey.nix
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}