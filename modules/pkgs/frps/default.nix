{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.frps;
  configDir = "${config.xdg.configHome}/frp";
  configFile = "${configDir}/frps.toml";
  environmentFile = "${configDir}/frps.env";

  escapeEnvironmentValue = value:
    lib.escapeShellArg (toString value);

  environmentText =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "${name}=${escapeEnvironmentValue value}") cfg.environment
    )
    + "\n";
in {

  options.services.frps = {
    enable = lib.mkEnableOption "the frp server (frps) user service";

    package = lib.mkPackageOption pkgs "frp" {};

    configText = lib.mkOption {
      type = lib.types.lines;
      default = ''
        bindAddr = "{{ .Envs.FRP_SERVER_INTRANET_ADDR }}"
        bindPort = {{ .Envs.FRP_SERVER_PORT }}

        [auth]
        method = "token"
        token = "{{ .Envs.FRP_TOKEN }}"

        [log]
        to = "console"
        level = "info"
        maxDays = 3
      '';
      description = ''
        Contents of the frps TOML configuration. Environment variables can be
        referenced using frp's {{ .Envs.NAME }} template syntax.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [lib.types.str lib.types.int]);
      default = {
        FRP_SERVER_INTRANET_ADDR = "0.0.0.0";
        FRP_SERVER_PORT = 7000;
        FRP_TOKEN = "change-me";
      };
      description = ''
        Variables written by Home Manager to the frps EnvironmentFile.
        Values, including secrets, are stored in the world-readable Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environment.FRP_TOKEN or "" != "change-me";
        message = "services.frps.environment.FRP_TOKEN must be changed before enabling frps";
      }
    ];

    home.packages = [cfg.package];

    xdg.configFile."frp/frps.toml".text = cfg.configText;
    xdg.configFile."frp/frps.env".text = environmentText;

    systemd.user.services.frps = {
      Unit = {
        Description = "frp server";
        Wants = ["network-online.target"];
        After = ["network-online.target"];
      };

      Service = {
        Type = "simple";
        EnvironmentFile = environmentFile;
        ExecStart = "${lib.getExe' cfg.package "frps"} -c ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
