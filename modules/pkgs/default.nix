{ config, pkgs, ... }:

{
  imports = [
    ./fish/fish.nix   
    ./starship/starship.nix  
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ripgrep 
      jq 
      yq-go 
      eza 
      fzf 
      just 
      neovim
      bat
      delta
      yazi
      tmux
      tmuxinator
      emacs
      rsync
      vim
      neofetch
      git
      tree
      fd
      curl
      caddy
      acme-sh
      xray
      gemini-cli
      chezmoi
      tmuxp
      ruby_3_5
      ranger
      opencode
    ;
    # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
  } ++ [ pkgs.nerd-fonts.jetbrains-mono ];


}
