{ config, pkgs, ... }:
let
  ohMyTmuxSrc = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "af33f07134b76134acca9d01eacbdecca9c9cda6"; 
    hash = "sha256-nXm664l84YSwZeRM4Hsweqgz+OlpyfwXcgEdyNGhaGA="; 
  };
in
{
  home.packages = with pkgs; [
    tmux
    tmuxinator
  ];

  xdg.configFile = {
    "tmux/tmux.conf".source = "${ohMyTmuxSrc}/.tmux.conf";
  };
}
