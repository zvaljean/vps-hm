{config, ...}: {
  # Machine-specific features stay in the private repository.
  emacs.enable = true;

  services.frps = {
    enable = true;
    tokenFile = "${config.xdg.configHome}/frp/token";
    logFile = "console";
    serverAddr = "0.0.0.0";
    serverPort = 10000;
  };
}
