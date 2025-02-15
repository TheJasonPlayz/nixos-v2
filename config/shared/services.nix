{ pkgs, config, lib, username, foundryvtt, hasGui ? false, hostname, ... }:

{
  services = lib.mkMerge [
    {
      /* AUDIO */
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };

      /* MISC */
      openssh.enable = true;
      rsyncd.enable = true;
      foundryvtt = lib.mkIf (hostname == "jasonw-laptop") {
        enable = true;
        hostName = hostname;
        minifyStaticFiles = true;
        proxyPort = 443;
        proxySSL = true;
        upnp = true;
        package = foundryvtt.packages.${pkgs.system}.foundryvtt_12;
      };
      blueman.enable = true;
    }

    lib.mkIf hasGui {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
      xserver = {
        enable = true;
        videoDrivers = lib.mkIf (config.networking.hostName == "${username}-c") [ "amdgpu" ];
        displayManager.lightdm = {
          enable = true;
          greeter.enable = true;
          greeters.slick.enable = true;
          xkb = {
            layout = "us,us,jp";
            variant = ",intl,";
          };
        };
      };
      xrdp = {
        enable = true;
        openFirewall = true;
        defaultWindowManager =  "startplasma-x11";
      };
    } 
  ];
}