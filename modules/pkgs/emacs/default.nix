{
  config,
  lib,
  pkgs,
  ...
}: let
  vps-emacs = pkgs.fetchFromGitHub {
    owner = "zvaljean";
    repo = "vps-emacs";
    rev = "286f6496965a9dd1f892c546cc61114c5ec1c11b";
    rootDir = "config";
    hash = "sha256-E5dQ0CHgNt4VMb6P23xbqjJtO27NDL84/QR8pv6acq8=";
  };
in {

  options.emacs = {
    enable = lib.mkEnableOption "the emacs trigger";
  };

  config = lib.mkIf config.emacs.enable {
    home.packages = [pkgs.emacs];
    xdg.configFile."emacs".source = "${vps-emacs}/";
  };
}
