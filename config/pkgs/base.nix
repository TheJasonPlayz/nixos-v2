{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./personal/ssh_privkey.nix)
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}