{ pkgs, lib, hasGui ? false, ... }:

{
  environment.systemPackages = [ lib.mkMerge [
    {
      # environment.systemPackages = with pkgs; [];
    }
    lib.mkIf hasGui {
      environment.systemPackages = with pkgs; [
        gparted
      ];
    }
  ] ];
}