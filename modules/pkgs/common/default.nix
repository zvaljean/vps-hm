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
        inetutils
        wget
        fastfetch
        fd
        ripgrep 
        jq 
        eza 
        fzf 
        bat
        tmux
        emacs
        vim-full
        chezmoi
        gnupg
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
