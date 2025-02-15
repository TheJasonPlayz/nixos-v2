{ username, ... }:

{
  imports = [
    ./home-manager.nix { inherit username; }
  ];
}