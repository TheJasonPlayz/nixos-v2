{ pkgs, ... }:

{
  system.stateVersion = "24.11";
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      plugin-files = "${pkgs.nix-plugins}/lib/nix/plugins";
      extra-builtins-file = [ ./pkgs/extra-builtins.nix ];
    };
  };
}