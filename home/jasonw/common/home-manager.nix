{ username, sops, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    file = {
      id_ed25519 = {
        force = true;
        text = builtins.readFile sops.secrets."ssh/priv_key".path;
        target = ".ssh/id_ed25519";
      };
    };
  };
}