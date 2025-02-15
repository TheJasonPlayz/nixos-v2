{ lib, pkgs, ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f1dd5b31-d987-4d01-a226-84c8c8fad884";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/05f07eec-5305-4006-9eee-1a5840592ea4";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-partuuid/c913de29-e9e7-4b88-bdfd-321cf6f50b31";
      fsType = "vfat";
    };
    "/mnt/windows" = {
      device = "/dev/disk/by-partuuid/dc41c2fc-4a88-45e3-92fd-a820a888852f";
      fsType = "ntfs";
    };
  };
  boot = {
    supportedFilesystems = {
      xfs = true;
      ntfs-3g = true;
    };
    loader = {
      timeout = 10;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  environment.systemPackages = with pkgs; [
    sbctl
    ntfs3g
  ];
}