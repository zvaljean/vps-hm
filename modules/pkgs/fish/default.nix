{ config, pkgs, lib, ... }:
{
  xdg.configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
  xdg.configFile."fish/completions/tmuxinator.fish" = 
     lib.mkIf config.programs.tmux.tmuxinator.enable {
       source = "${pkgs.tmuxinator}/share/fish/vendor_completions.d/tmuxinator.fish";
     };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      hm-b = "home-manager build";
      hm-s = "home-manager switch";
      hm-gen = "home-manager generations";
      hm-pkg = "home-manager packages";
    };

    shellAliases = {

      mux = "tmuxinator";
      hm = "home-manager";

      l = "ls -lhF --group-directories-first";
      ld = "eza -ld */ --no-quotes --time-style long-iso";
      lla = "eza -lah --no-quotes --time-style long-iso";
      ll = "eza -lh --no-quotes --time-style long-iso";
      llr = "eza -lhr --no-quotes --time-style long-iso";
      lls = "eza -lh -s size --no-quotes --time-style long-iso";
      llt = "eza -lh -s time --no-quotes --time-style long-iso";
      lltr = "eza -lhr -s time --no-quotes --time-style long-iso";
      
    };

     loginShellInit = ''

     # -g global, -x  xexport 
     set -gx GOROOT /opt/tools/go
     set -gx GOPATH /opt/tools/repo/go

     fish_add_path ~/.local/bin
     fish_add_path $GOROOT/bin
     fish_add_path $GOPATH/bin

     '';

    interactiveShellInit = ''

     set -g fish_greeting 

     if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
     end


     if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock"
         ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
     end

     set -gx SSH_AUTH_SOCK "$HOME/.ssh/ssh_auth_sock"
     if test -S "$HOME/.gnupg/S.gpg-agent"
         gpgconf --kill gpg-agent 2>/dev/null
         set REAL_SOCKET (gpgconf --list-dirs agent-socket)
         mkdir -p (dirname "$REAL_SOCKET")
         rm -f "$REAL_SOCKET"
         ln -sf "$HOME/.gnupg/S.gpg-agent" "$REAL_SOCKET"
     end

    '';

    plugins = [
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
    ];

  };
}
