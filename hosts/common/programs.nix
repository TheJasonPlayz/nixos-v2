{ lib, hasGui ? false, ... }:

lib.mkMerge [
  {
    programs = {
      direnv.enable = true;
      ssh.startAgent = true;
    };
  }

  {
    programs = lib.mkIf hasGui {
      firefox.enable = true;
      steam.enable = true;
    };
  }
]
  