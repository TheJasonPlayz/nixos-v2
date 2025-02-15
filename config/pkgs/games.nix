{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher
    protonup-qt
    lutris
    heroic
    xmage
  ];
}