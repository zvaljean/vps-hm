{ config, pkgs, ... }:
{
  home.sessionVariables = {
    LANG = "C.UTF-8";
    LC_ALL = "C.UTF-8";
    EDITOR = "vim";
    VIUAL = "vim";
    TERM = "xterm-256color";
  };

}
