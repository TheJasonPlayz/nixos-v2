{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
    python313
    fnm
    vscodium
    direnv
  ];
}