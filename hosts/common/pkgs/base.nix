{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ( callPackage ./custom/ssh_privkey.nix { })
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}