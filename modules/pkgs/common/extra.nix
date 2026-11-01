{
  config,
  pkgs,
  ...
}: {
  options.extra-tools = {
    enable = lib.mkEnableOption "the extra tools trigger";
  };

  config = lib.mkIf config.extra-tools.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        ranger
        neovim
        gnupg
        fontconfig
        chezmoi
        # devenv
        yt-dlp
        ;
    };
  };
}
