{ pkgs, ... }:

{
  services.usbmuxd.enable = true;

  programs = {
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