{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.frps;
  configDir = "${config.xdg.configHome}/frp";
  configFile = "${configDir}/frps.toml";
in {

  options.services.frps = {
    enable = lib.mkEnableOption "the frp server (frps) user service";

    package = lib.mkPackageOption pkgs "frp" {};

    configText = lib.mkOption {
      type = lib.types.lines;
      default = ''
        bindAddr = "${cfg.serverAddr}"
        bindPort = ${cfg.serverPort}

        [auth]
        method = "token"
        tokenSource.type = "file"
        tokenSource.file.path = "${cfg.tokenFile}"

        [log]
        to = "${cfg.logFile}"
        level = "info"
        maxDays = 3
      '';
      description = ''
        Contents of the frps TOML configuration.
      '';
    };

    tokenFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/frp/server_token";
      example = "/run/secrets/frps-token";
      description = ''
        Path to the token file that already exists on the target machine.
        Home Manager only references this file and does not create or manage it.
      '';
    };


    logFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/log/frps.log";
      example = "/var/log/frps.log";
      description = '' log files '';
    };
    serverAddr = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      example = "0.0.0.0";
      description = '' server ip '';
    };

    serverPort = lib.mkOption {
      type = lib.types.int;
      default = 7000;
      example = 7000;
      description = '' server port'';
    };
    

  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."frp/frps.toml".text = cfg.configText;

    systemd.user.services.frps = {
      Unit = {
        Description = "frp server";
        Wants = ["network-online.target"];
        After = ["network-online.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "frps"} -c ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
