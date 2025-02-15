{ pkgs, lib, hasGui ? false, ... }:


lib.mkMerge [
    {
      environment.systemPackages = [];
    }
    {
      environment.systemPackages = lib.mkIf hasGui (with pkgs; [
        gparted
      ]);
    }
]