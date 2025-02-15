{ username, readSops, ... }:

let
  secrets = readSops ../../../secrets.yaml;
in
{
  programs.home-manager.enable = true;
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    file = {
      id_ed25519 = {
        force = true;
        text =  secrets.ssh.priv_key;
        target = ".ssh/id_ed25519";
      };
    };
  };
}