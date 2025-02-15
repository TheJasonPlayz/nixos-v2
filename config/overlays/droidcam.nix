final: prev: 
let
  deps = with prev; [
    libimobiledevice
    usbmuxd
  ];
in
{
  droidcam = prev.droidcam.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ deps;
  });
}