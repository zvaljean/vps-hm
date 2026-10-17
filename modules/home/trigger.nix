{ config, pkgs, ... }:
{
  services.frps = {
    enable = true;

    environmentFile = "/etc/frp/token";
    serviceEnvironment = {
      FRP_SERVER_INTRANET_ADDR = "0.0.0.0";
      FRP_SERVER_PORT = 7000;
    };
  };

}
