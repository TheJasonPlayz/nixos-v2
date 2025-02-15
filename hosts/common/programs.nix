{ lib, hasGui ? false, ... }:

lib.mkMerge [
  {
    programs = {
      direnv.enable = true;
    };
  }

  {
    programs = lib.mkIf hasGui {
      firefox.enable = true;
    };
  }
]
  