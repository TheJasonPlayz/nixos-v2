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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, sops-nix, foundryvtt, lanzaboote, home-manager, ...}: 
  let
    username = "jasonw";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    sharedModules = [ 
      home-manager.nixosModules.home-manager
      foundryvtt.nixosModules.foundryvtt
      sops-nix.nixosModules.sops
    ];
    host_func = hostname: prefixlen: builtins.substring prefixlen (pkgs.lib.stringLength hostname - prefixlen) hostname;
    hm-config = host: user: { ... }: {
      home-manager = {
        users.${user} = import ./home/${user}/${host}.nix { inherit username; } // { inherit username; };
        sharedModules = [ sops-nix.homeManagerModules.sops ];
      };
    };
    mkNixos = hostname: hasGui: 
    let
      inherit (nixpkgs.lib) nixosSystem;
      host = host_func hostname 7;
    in
    nixosSystem {
      specialArgs = { inherit foundryvtt hasGui hostname username; };
      modules = sharedModules ++ [
        ./hosts/common
        ./hosts/${host}
        (hm-config host username)
      ] ++ (if (hostname == "jasonw-pc") then [lanzaboote.nixosModules.lanzaboote] else []);
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
    packages.${system}.default = ( pkgs.callPackage ./hosts/common/pkgs/custom/ssh_privkey.nix { } );
  };
}
