{ config, pkgs, ... }:

{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      starship
    ;
  };

  # https://codeberg.org/justgivemeaname/.dotfiles/src/branch/main/home-manager/packages/starship/starship.nix
  #      the standard path under ~/.config/ 
	#           to find the file       Where the file is located relative to this .nix file
	#                    |                             |
	#                    V                             V
	xdg.configFile."starship.toml".source = ./starship.toml;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
