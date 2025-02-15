{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, foundryvtt, lanzaboote, ...}: 
  let 
    username = "jasonw";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    nixosSystem = nixpkgs.lib.nixosSystem;
    sharedModules = [ 
      foundryvtt.nixosModules.foundryvtt
      ./config/shared/nixos.nix 
      ./config/shared/nixpkgs.nix
      ./config/shared/i18n.nix
      ./config/shared/security.nix
      ./config/shared/networking.nix
      ./config/shared/users.nix
      ./config/shared/services.nix
      ./config/shared/time.nix
    ];
  in 
  {
    nixosConfigurations = {
      jasonw-pc = let
        hostname = "jasonw-pc";
        hasGui = true;
      in
      nixosSystem {
        specialArgs = { inherit foundryvtt hasGui hostname username; };        
        modules = sharedModules ++ [
          lanzaboote.nixosModules.lanzaboote
          ./config/hosts/pc/boot.nix
          ./config/hosts/pc/hardware.nix
          ./config/hosts/pc/configuration.nix
        ] ++ (import ./config/hosts/pc/pkgs.nix);
      };
      jasonw-laptop = let
        hostname = "jasonw-laptop";
        hasGui = true;
      in
      nixosSystem {
        specialArgs = { inherit foundryvtt hasGui hostname; };
        modules = sharedModules ++ [
          ./config/hosts/laptop/boot.nix
          ./config/hosts/laptop/hardware.nix
          ./config/hosts/laptop/configuration.nix
        ] ++ (import ./config/hosts/laptop/pkgs.nix);
      };
    };
    devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          (python312.withPackages (python-pkgs: with python-pkgs; [
            pyyaml
            requests
          ]))
          nixd
          bashInteractive
          sops
          age
        ];
        shellHook = ''
          alias rebuild="./scripts/rebuild.py; sudo nixos-rebuild switch --flake /etc/nixos\"
          codium .
        '';
    };
  };
}
