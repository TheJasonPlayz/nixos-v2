{ hostname, ... }:

{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    dhcpcd.enable = true;
    extraHosts = ''
      10.0.0.4 mage-server
    '';
  };
}