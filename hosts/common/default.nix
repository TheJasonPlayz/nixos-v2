{ ... }:

{ 
  imports = [
  ./nixos.nix 
  ./nixpkgs.nix
  ./i18n.nix
  ./security.nix
  ./networking.nix
  ./users.nix
  ./services.nix
  ./time.nix
  ./programs.nix
  ./sops.nix
  ]; 
}