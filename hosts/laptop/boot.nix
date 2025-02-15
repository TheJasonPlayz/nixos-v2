{ ... }:

{
  fileSystems = {
    "/" =
    { device = "/dev/disk/by-uuid/94a91755-b3b4-4424-bad2-d00c8a2f5567";
      fsType = "ext4";
    };
    "/boot" =
    { device = "/dev/disk/by-uuid/B125-E9B8";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  swapDevices =
    [ { device = "/dev/disk/by-uuid/25f52e7b-50ff-4efb-8bc8-7cb7e2f26121"; }
    ];

    boot = {
      loader.systemd-boot.enable = true;
      kernelModules = [ "kvm-intel " ];
      initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
    };
}