{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (import ./personal/ssh_privkey.nix)
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}