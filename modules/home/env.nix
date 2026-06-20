{ config, pkgs, ... }:
{
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US:UTF-8";
    LANGUAGE = "en_US:en";
    EDITOR = "vim";
    VIUAL = "vim";
    TERM = "xterm-256color";
  };

}
