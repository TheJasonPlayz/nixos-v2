{ ... }:

{
  imports = [
    ./home-manager.nix
    ../../../hosts/common/sops.nix
    ../../../hosts/common/extra-builtins.nix
  ];
}