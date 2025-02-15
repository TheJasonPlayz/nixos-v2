{ config, username, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "jasonw";
    homeDirectory = "/home/jasonw";
    stateVersion = "24.11";
    file = {
      id_ed25519 = {
        force = true;
        source = config.sops.secrets."ssh/priv_key".path;
        target = ".ssh/id_ed25519";
      };
    };
  };
}