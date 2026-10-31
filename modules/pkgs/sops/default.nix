{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {

  _class = "homeManager";

  imports = [inputs.sops-nix.homeManagerModules.sops];

  options.sops.enable = lib.mkEnableOption "SOPS CLI and the GnuPG secret.";

  config = lib.mkIf config.sops.enable {
    # sops-nix 提供运行时解密，交互加密和编辑另需 SOPS CLI。
    home.packages = [pkgs.sops];

    # 测试脚本和示例密文位于 secrets/demo，当前仅启用 FRP 秘密。
    # 只引用仓库外的密钥环路径，不能把私钥作为 Nix path 导入 store。
    #   defaultSymlinkPath = "${config.home.homeDirectory}/.local/secrets";
    sops = {
      gnupg.home = "${config.home.homeDirectory}/.gnupg";
      # 表示不从 SSH 私钥派生密钥
      gnupg.sshKeyPaths = [];

      # defaultSopsFile = ./secrets/demo/secrets.yaml;
      # secrets.example-token = {
      #   key = "example_token";
      #   mode = "0400";
      # };

      secrets.frp = {
        # path 是秘密文件的链接路径，不能占用 FRP 配置目录本身。
        path = "${config.xdg.configHome}/frp/token";
        sopsFile = ./secrets/frp-token.enc;
        format = "binary";
        mode = "0400";
      };
    };
  };
}
