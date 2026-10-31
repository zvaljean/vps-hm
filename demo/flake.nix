{
  description = "Public Home Manager configuration with private machine modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This repository is private. The target machine needs SSH access to it.
    private-config = {
      url = "git+ssh://git@git.example.com/infra/home-manager-private.git?ref=main";
      flake = true;
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager;
      private-config = inputs."private-config";
    in {
      # Expose one pure Flake output for every machine in the private repo.
      homeConfigurations = nixpkgs.lib.mapAttrs (_hostname: machineModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./common.nix
            machineModule
          ];
        }
      ) private-config.homeManagerModules;
    };
}
