{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ nixpkgs, ...}: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in 
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        (pkgs.python312.withPackages (python-pkgs: with python-pkgs; [
          GitPython
          tqdm
          pyyaml
        ]))
      ];
      shellHook = ''
        codium
      '';
    };
  };
}