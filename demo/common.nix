{ pkgs, ... }:
{
  imports = [
    ../modules/home
    ../modules/pkgs
  ];

  home.username = "data";
  home.homeDirectory = "/home/data";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  programs.fish.enable = true;

  home.packages = [
    pkgs.ripgrep
  ];
}
