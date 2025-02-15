{ ... }:

{
  imports = [
    ./home-manager.nix
    ../../../hosts/common/sops.nix
    ../../../hosts/commmon/extra-builtins.nix
  ];
}