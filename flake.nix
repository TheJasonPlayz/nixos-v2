{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, foundryvtt, lanzaboote, home-manager, ...}: 
  let
    username = "jasonw";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    sharedModules = [ 
      home-manager.nixosModules.home-manager
      foundryvtt.nixosModules.foundryvtt
      ./hosts/common/nixos.nix 
      ./hosts/common/nixpkgs.nix
      ./hosts/common/i18n.nix
      ./hosts/common/security.nix
      ./hosts/common/networking.nix
      ./hosts/common/users.nix
      ./hosts/common/services.nix
      ./hosts/common/time.nix
      ./hosts/common/programs.nix
    ];
    host_func = hostname: prefixlen: builtins.substring prefixlen (pkgs.lib.stringLength hostname - prefixlen) hostname;
    hm-config = host: user: { ... }: {
      home-manager = {
        users.${user} = import ./home/${user}/${host}.nix;
        extraSpecialArgs = {};
      };
    };
    mkNixos = hostname: hasGui: 
    let
      inherit (pkgs.lib) mkIf;
      inherit (nixpkgs.lib) nixosSystem;
      host = host_func hostname 7;
    in
    nixosSystem {
      specialArgs = { inherit foundryvtt hasGui hostname username; };
      modules = sharedModules ++ [
        (mkIf (hostname == "jasonw-pc") lanzaboote.nixosModules.lanzaboote)
        ./hosts/${host}/boot.nix
        ./hosts/${host}/hardware.nix
        ./hosts/${host}/configuration.nix
        (hm-config host username)
      ] ++ ( import ./hosts/${host}/pkgs.nix);
    };
  in
  {
    nixosConfigurations = {
      jasonw-pc = mkNixos "jasonw-pc" true;
      jasonw-laptop = mkNixos "jasonw-laptop" true;
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
        alias rebuild="./scripts/rebuild.py; sudo nixos-rebuild switch --flake /etc/nixos"
        codium .
      '';
    };
    formatter = pkgs.nixfmt-rfc-style;
  };
}
