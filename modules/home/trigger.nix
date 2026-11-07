{
  config,
  pkgs,
  ...
}: {
  extra-tools.enable = true;

  sops.enable = false;
  emacs.enable = false;
  tmux.enable = true;
  yt-dlp.enable = true;
  devenv.enable = false;
  neovim.enable = true;

  services.frps = {
    enable = true;
    tokenFile = "${config.xdg.configHome}/frp/token";
    logFile = "console";
    serverAddr = "0.0.0.0";
    serverPort = 10001;
  };
}
