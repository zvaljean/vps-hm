{ config, pkgs, ... }:

{
  # packages 可以执行脚本
  # home.packages =  [ (pkgs.writeShellScriptBin "my-hello" ''
  #      echo "Hello, ${config.home.username}!"
  #      echo "system, ${pkgs.system}!"
  #      echo "system, ${zzv}!"
  #    '')
  #   ];

  home.file = {

  };

  # 会合并到 fish 中
  home.shellAliases = {
    ff = "exec fish -l";
    # cm = "chezmoi";
    # hm = "home-manager";
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

}
