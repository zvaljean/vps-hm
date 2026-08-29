{ config, pkgs, ... }:
  {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        git
        tree
        #curl
        curlFull
        rsync
        ranger
        socat
        net-tools
        acl

        fish

        inetutils
        wget

        fastfetch
        fd
        ripgrep 
        jq 
        eza 
        fzf 
        bat
        #just 
        #neovim
        #delta
        tmux
        emacs
        vim-full
        #neofetch
        #caddy
        #acme-sh
        #xray
        chezmoi
        #ruby_3_5
        #yazi
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
