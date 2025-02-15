{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}