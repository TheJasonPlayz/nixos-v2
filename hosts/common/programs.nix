{ lib, hasGui ? false, ... }:

lib.mkMerge [
  {
    programs = {
      direnv.enable = true;
    };
  }

  lib.mkIf hasGui {
    programs = {
      firefox.enable = true;
    };
  }
]
  