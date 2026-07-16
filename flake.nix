{
  description = "Home Manager configuration of data ";
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "data";
    in
    {
      # add formatter
      formatter.${system} = pkgs.alejandra;

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "26.05"; 
            home.shell.enableFishIntegration = true;
            programs.home-manager.enable = true;
          }

          ./modules/home
          ./modules/pkgs
        ];

      };
    };
}
