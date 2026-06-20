{ config, pkgs, ... }:
  {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        ripgrep 
        jq 
        eza 
        fzf 
        bat
        delta
        rsync
        vim
        fastfetch
        git
        tree
        fd
        curl
        fontconfig
      ;
    } ++ [ pkgs.nerd-fonts.jetbrains-mono ];
}
