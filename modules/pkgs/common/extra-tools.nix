{
  config,
  pkgs,
  lib,
  ...
}: {
  options.extra-tools = {
    enable = lib.mkEnableOption "the extra tools trigger";
  };

  config = lib.mkIf config.extra-tools.enable {
    home.packages =
      builtins.attrValues {
        inherit
          (pkgs)
          ranger
          gnupg
          fontconfig
          chezmoi
          gnumake
          ;
      }
      ++ [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.lua54Packages.lua
        pkgs.lua54Packages.luarocks
      ];
  };
}
