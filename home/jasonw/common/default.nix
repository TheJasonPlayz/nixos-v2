{ sops-nix, ... }:

{
  imports = [
    ./home-manager.nix
    sops-nix.homeManagerModules.sops
  ];
}