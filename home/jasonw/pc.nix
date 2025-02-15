{ sops-nix, ... }:

{
  imports = [
    ./common { inherit sops-nix; }
  ];
}