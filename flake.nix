{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ nixpkgs, ...}: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    nixosSystem = pkgs.lib.nixosSystem;
  in 
  {
    jasonw-pc = nixosSystem {
      modules = [

    ];
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        (python312.withPackages (python-pkgs: with python-pkgs; [
          GitPython
          tqdm
          pyyaml
        ]))
        nixd
      ];
      shellHook = ''
        codium .
      '';
    };
  };
}
