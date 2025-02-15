{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (import ./custom/ssh_privkey.nix)
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}