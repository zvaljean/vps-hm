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
    ;
  };


}
