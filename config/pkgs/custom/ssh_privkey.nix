{ stdenv, pkgs, ... }:

stdenv.mkDerivation {
    name = "ssh_privkey";

    src = pkgs.writeText "ssh" ''-----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
  QyNTUxOQAAACC/4XjjizI60/wwEIrI9qZ3NDJCkFaKvUV1DFFFlRvhnwAAAJis8loJrPJa
  CQAAAAtzc2gtZWQyNTUxOQAAACC/4XjjizI60/wwEIrI9qZ3NDJCkFaKvUV1DFFFlRvhnw
  AAAEC1zdOj8hJ/k3EKqbjsKudKDrBNmAJRMzOiLeJBIhaOir/heOOLMjrT/DAQisj2pnc0
  MkKQVoq9RXUMUUWVG+GfAAAAD3RoZWphQEpBU09OU19QQwECAwQFBg==
  -----END OPENSSH PRIVATE KEY-----'';


    installPhase = ''
      mkdir $out
      cp $ssh $out/id_ed25519
      ln -s "$HOME/.ssh/id_ed25519" "$out/id_ed25519"
    '';

    dontUnpack = true;
}