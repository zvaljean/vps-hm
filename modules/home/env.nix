{ config, pkgs, ... }:
{
  home.sessionVariables = {
    LANG = "C.UTF-8";
    LC_ALL = "C.UTF-8";
    LANGUAGE = "C";
    EDITOR = "vim";
    VIUAL = "vim";
    TERM = "xterm-256color";
  };

}
