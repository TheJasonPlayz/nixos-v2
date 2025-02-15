{ config, pkgs, username, ... }:

{
  hardware = {
    /* Display */
    amdgpu = {
      opencl.eanble = true;
      amdvlk.enable = true;
      initrd.enable = true;
    };
    graphics = {
      enable32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    /* Firmware */
    enableRedistributableFirmware = true;

    /* Peripherals */
    openrazer = {
      enable = true;
      users = [ username ];
    };

    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };
}