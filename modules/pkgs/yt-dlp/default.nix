{
  config,
  pkgs,
  lib,
  ...
}: {
  options.yt-dlp.enable = lib.mkEnableOption "yt-dlp package trigger.";

  config = lib.mkIf config.yt-dlp.enable {
    home.packages = [pkgs.yt-dlp];
  };
}
