{
  config,
  lib,
  pkgs,
  ...
}: {
  options.emacs = {
    enable = lib.mkEnableOption "the emacs trigger";
  };

  config = lib.mkIf config.emacs.enable {
    home.packages = [pkgs.emacs];
    xdg.configFile."emacs".source = ./config;
  };
}
