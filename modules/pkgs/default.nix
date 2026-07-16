# https://nix-community.github.io/home-manager/index.xhtml#sec-module-auto-importing
{ lib, ... }:
let
  dir = builtins.readDir ./.;
  autoImportFilter = name: type:
    let
      isValidFile = type == "regular" && name != "default.nix" && lib.strings.hasSuffix ".nix" name;
      isValidDir = type == "directory";
      isNotIgnored = !(lib.strings.hasPrefix "_" name);
    in
      isNotIgnored && (isValidFile || isValidDir);

  validModules = builtins.filter (name: autoImportFilter name dir.${name}) (builtins.attrNames dir);
in
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
      # tmuxinator
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
      fontconfig
      gnumake
    ;
    # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
  } ++ [ pkgs.nerd-fonts.jetbrains-mono ];


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
      # tmuxinator
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
      fontconfig
      gnumake
    ;
    # inherit (pkgs) 只用于一级属性, ++ 拼接列表，单独追加 pkgs.nerd-fonts.jetbrains-mono
  } ++ [ pkgs.nerd-fonts.jetbrains-mono ];

  imports = map (name: ./${name}) validModules;
}
