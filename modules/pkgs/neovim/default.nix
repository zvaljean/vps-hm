{
  config,
  pkgs,
  lib,
  ...
}: let
  vps-neovim = pkgs.fetchFromGitHub {
    owner = "zvaljean";
    repo = "vps-nvim";
    rev = "2bf1d65a20e490de688c46d08d5e73b3f0109466";
    hash = "sha256-f7vQlS7S8ZZ99tUTtiBOgK/1Uev6qamKMlzppvKhB7Q=";
  };
in {
  options.neovim = {
    enable = lib.mkEnableOption "the neovim trigger";
  };

  config = lib.mkIf config.neovim.enable {
    home.packages = [pkgs.neovim];
    xdg.configFile."nvim".source = "${vps-neovim}/";
  };
}
