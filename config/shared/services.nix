{ config, lib, username, ... }:

{
  services = {
    /* DISPLAY */
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
    
  };
}