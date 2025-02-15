{ lib, ... }:

{
  nixpkgs = {
    overlays = [ (import ../overlays/xmage.nix) (import ../overlays/droidcam.nix) ];
    config = {
      allowUnfree = true;
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
}