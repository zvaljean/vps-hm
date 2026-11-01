{
  config,
  pkgs,
  unstablePkgs,
  lib,
  ...
}: let
  ohMyTmuxSrc = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "af33f07134b76134acca9d01eacbdecca9c9cda6";
    hash = "sha256-nXm664l84YSwZeRM4Hsweqgz+OlpyfwXcgEdyNGhaGA=";
  };
in {
  options.tmux.enable = lib.mkEnableOption "tmux config trigger.";

  config = lib.mkIf config.tmux.enable {

    home.packages = builtins.attrValues {
      tmuxinator = unstablePkgs.tmuxinator;
      tmux = pkgs.tmux;
    };

    xdg.configFile = {
      "tmux/tmux.conf".source = "${ohMyTmuxSrc}/.tmux.conf";
    };
  };
}
