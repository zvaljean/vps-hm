{
  description = "Home Manager configuration of data ";
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    username = "data";
    homeDir = "/home/data";
  in {
    # add formatter
    formatter.${system} = pkgs.alejandra;

    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit unstablePkgs inputs;
      };
      modules = [
        {
          home.username = username;
          home.homeDirectory = homeDir;
          home.stateVersion = "26.05";
          programs.home-manager.enable = true;
        }
        ./modules/home
        ./modules/pkgs
        ./modules/home/trigger.nix
      ];
    };
  };
}
