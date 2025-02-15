{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sage
    sagetex
    python312Packages.jupyterlab
    jupyter
  ];
}