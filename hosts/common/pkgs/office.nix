{ pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    libreoffice-qt6-fresh
    davinci-resolve
    tartube-yt-dlp
    inkscape
  ];
}
