{
  description = "Home Manager configurations for VPS users";
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    mkHome = {
      username,
      homeDirectory,
      extraModules ? [],
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules =
          [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
              home.stateVersion = "26.05";
              programs.home-manager.enable = true;
            }
            ./modules/home
            ./modules/pkgs
            ./modules/home/trigger.nix
          ]
          ++ extraModules;
      };
  in {
    # add formatter
    # formatter.${system} = pkgs.alejandra;

    homeConfigurations = {
      data = mkHome {
        username = "data";
        homeDirectory = "/home/data";
      };
      root = mkHome {
        username = "root";
        homeDirectory = "/root";
        extraModules = [
          ({lib, ...}: {
            services.frps.enable = lib.mkForce false;
          })
        ];
      };
    };
  };
}
