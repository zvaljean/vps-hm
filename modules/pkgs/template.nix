{ config, pkgs, ... }:

{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      fish
    ;
  };

  programs. = {
    enable = true;
  };
}
