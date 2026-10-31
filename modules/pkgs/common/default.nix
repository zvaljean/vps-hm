{
  config,
  pkgs,
  ...
}: {
  home.packages =
    builtins.attrValues {
      inherit
        (pkgs)
        git
        tree
        #curl
        curlFull
        rsync
        ranger
        acl
        socat
        net-tools
        inetutils
        nmap
        iproute2
        netcat-openbsd
        fastfetch
        wget
        fd
        ripgrep
        jq
        eza
        fzf
        bat
        neovim
        # vim-full
        gnupg
        fontconfig
        gnumake
        # sops
        # age
        chezmoi
        devenv
        yt-dlp
        ;
      # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
    }
    ++ [pkgs.nerd-fonts.jetbrains-mono];
}
