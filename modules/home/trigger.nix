{
  config,
  pkgs,
  ...
}: {
  sops.enable = false;
  emacs.enable = false;
  services.frps = {
    enable = false;
    tokenFile = "${config.xdg.configHome}/frp/token";
    logFile = "console";
    serverAddr = "0.0.0.0";
    serverPort = 10000;
  };
}
