{ config, pkgs, lib, ... }:
{
  _class = "homeManager";
  programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
  };
}
