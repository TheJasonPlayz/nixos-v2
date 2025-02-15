{ pkgs, ... }:

{
  system.stateVersion = "24.11";
  nix = {
    extraOptions = ''
      plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
    '';
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}