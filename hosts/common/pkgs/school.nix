{ pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    obsidian
    anki-bin
  ];
}
