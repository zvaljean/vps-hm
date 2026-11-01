{
  config,
  pkgs,
  lib,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "neovim package trigger.";

  config = lib.mkIf config.neovim.enable {
    home.packages = [ pkgs.neovim ];
  };
}
