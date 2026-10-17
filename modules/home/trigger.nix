{ config, pkgs, ... }:
{
  services.frps = {
    enable = true;

    tokenFile = "/etc/frp/token";
    logFile = "/var/log/frps.log";
    serverAddr = "0.0.0.0";
    serverPort = 7000;
  };

}
