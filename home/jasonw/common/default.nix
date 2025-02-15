{ username, ... }:

{
  inherit username;
  imports = [
    ./home-manager.nix { inherit username; }
  ];
}