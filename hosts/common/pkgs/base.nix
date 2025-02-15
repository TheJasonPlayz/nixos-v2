{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    # ( pkgs.callPackage ./custom/ssh_privkey.nix { inherit username; })
    rsync
    wget
    unzip
    fd
    parted
    git
  ];
}