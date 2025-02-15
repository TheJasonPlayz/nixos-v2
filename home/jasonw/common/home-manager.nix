{ username, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "jasonw";
    homeDirectory = "/home/jasonw";
    stateVersion = "24.11";
  };
}