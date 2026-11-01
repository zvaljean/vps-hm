{
  config,
  pkgs,
  lib,
  ...
}: {
  options.devenv.enable = lib.mkEnableOption "devenv package trigger.";

  config = lib.mkIf config.devenv.enable {
    home.packages = [pkgs.devenv];
  };
}
