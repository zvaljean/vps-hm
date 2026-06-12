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


     # -g global, -x  xexport 
     set -gx GOROOT /opt/tools/go
     set -gx GOPATH /opt/tools/repo/go

     fish_add_path ~/.local/bin
     fish_add_path $GOROOT/bin
     fish_add_path $GOPATH/bin

     if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock"
         ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
     end

     set -gx SSH_AUTH_SOCK "$HOME/.ssh/ssh_auth_sock"
     # GPG Agent 动态软链接接管
     if test -S "$HOME/.gnupg/S.gpg-agent"
         # 1. 杀死系统可能自动唤醒的空壳 Agent
         gpgconf --kill gpg-agent 2>/dev/null

         # 2. 动态获取当前系统 GPG 真正期待的套接字路径 (自动包含正确的 UID)
         set REAL_SOCKET (gpgconf --list-dirs agent-socket)

         # 3. 确保目录存在，并强制将默认路径软链接到 SSH 建立的隧道上
         mkdir -p (dirname "$REAL_SOCKET")
         rm -f "$REAL_SOCKET"
         ln -sf "$HOME/.gnupg/S.gpg-agent" "$REAL_SOCKET"
     end

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
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
    ];

    shellAliases = {

      mux = "tmuxinator";
      hm = "home-manager";
      cm = "chezmoi";

      l = "ls -lhF --group-directories-first";
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
