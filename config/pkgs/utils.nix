{ pkgs, lib, hasGui ? false, ... }:

lib.mkMerge [
  {
    # environment.systemPackages = with pkgs; [];
  }
  lib.mkIf hasGui {
    environment.systemPackages = with pkgs; [
      gparted
    ];
  }
]