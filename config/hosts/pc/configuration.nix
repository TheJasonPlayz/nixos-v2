{ pkgs, ... }:

{
  services.usbmuxd.enable = true;

  programs = {
    firefox.enable = true;
    steam.enable = true;
    droidcam.enable = true;
    chromium.enable = true;
    _1password-gui.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libimobiledevice
    usbmuxd
    razergenie
  ];
}