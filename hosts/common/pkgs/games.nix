{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher
    badlion-client
    protonup-qt
    lutris
    heroic
    xmage
  ];
}