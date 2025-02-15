{ ... }:

{
  imports = [
    ./home-manager.nix
    ../../../hosts/common/sops.nix
    ../../../hosts/common/pkgs/extra-builtins.nix
  ];
}