{ config, pkgs, ... }:
  {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        ripgrep 
        jq 
        eza 
        fzf 
        just 
        neovim
        bat
        delta
        yazi
        tmux
        emacs
        rsync
        vim
        #neofetch
        fastfetch
        git
        tree
        fd
        curl
        caddy
        acme-sh
        xray
        chezmoi
        ruby_3_5
        ranger
        opencode
        fontconfig
        gnumake
      ;
      # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
    } ++ [ pkgs.nerd-fonts.jetbrains-mono ];
}
