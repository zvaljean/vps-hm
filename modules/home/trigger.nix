{ config, pkgs, ... }:
{
  services.frps = {
    enable = true;

    tokenFile = "${config.xdg.configHome}/frp/token";
    logFile = "console";
    serverAddr = "0.0.0.0";
    serverPort = 10000;
  };

}
