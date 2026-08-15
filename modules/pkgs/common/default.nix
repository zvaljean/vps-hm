{ config, pkgs, ... }:
  {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        ripgrep 
        jq 
        eza 
        fzf 
        #just 
        neovim
        bat
        #delta
        tmux
        emacs
        rsync
        vim-full
        #neofetch
        fastfetch
        git
        tree
        fd
        curl
        #caddy
        #acme-sh
        #xray
        chezmoi
        ruby_3_5
        #yazi
        ranger
        fontconfig
        gnumake
        devenv
        nmap
        iproute2
        netcat-openbsd
      ;
      # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
    } ++ [ pkgs.nerd-fonts.jetbrains-mono ];
}
