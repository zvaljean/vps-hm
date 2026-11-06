{
  config,
  pkgs,
  ...
}: {
  imports = [./extra-tools.nix];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      git
      tree
      #curl
      curlFull
      rsync
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
      ;
  };
}
