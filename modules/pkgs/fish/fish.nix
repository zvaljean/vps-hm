{ config, pkgs, ... }:

{

  home.shell.enableFishIntegration = true;

  # https://wiki.nixos.org/wiki/Fish
  # https://nixos.wiki/wiki/Fish
  home.packages = builtins.attrValues {
    inherit (pkgs)
      fish
      grc
      zoxide
      tmuxinator
    ;
  };

  xdg.configFile."fish/completions/tmuxinator.fish".source = "${pkgs.tmuxinator}/share/fish/vendor_completions.d/tmuxinator.fish";
  xdg.configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";

  programs.fish = {
    enable = true;

    # loginShellInit = ''
    # if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    #    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    # end
    # '';

    interactiveShellInit = ''

     if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
     end


     set fish_greeting 
     ${pkgs.zoxide}/bin/zoxide init fish | source

     set GOROOT /opt/tools/go/
     set GOPATH /opt/repo/golang
     set PATH ~/.local/bin $GOROOT/bin $PATH
     export GOROOT GOPATH 
    '';

    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      # { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      # {
      #   name = "grc";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #     repo = "plugin-grc";
      #     rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
      #     sha256 = "sha256-NQa12L0zlEz2EJjMDhWUhw5cz/zcFokjuCK5ZofTn+Q=";
      #   };
      # }
      # # Manually packaging and enable a plugin
      #   {
      #     name = "z";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "jethrokuan";
      #       repo = "z";
      #       rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #       sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #     };
      #   }
    ];

    shellAliases = {

      mux = "tmuxinator";

      hm = "home-manager ";

      l = "ls -lhF --group-directories-first"
      ld = "eza -ld */ --no-quotes --time-style long-iso";
      lla = "eza -lah --no-quotes --time-style long-iso";
      ll = "eza -lh --no-quotes --time-style long-iso";
      llr = "eza -lhr --no-quotes --time-style long-iso";
      lls = "eza -lh -s size --no-quotes --time-style long-iso";
      llt = "eza -lh -s time --no-quotes --time-style long-iso";
      lltr = "eza -lhr -s time --no-quotes --time-style long-iso";
      
    };

    functions = {
      # __z = ''
      #   function __z  
      #   __zoxide_z "$argv"
      #   end
      # '';
    };
  };
}
