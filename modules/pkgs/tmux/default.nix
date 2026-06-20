{ config, pkgs, ... }:
let
  ohMyTmuxSrc = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "af33f07134b76134acca9d01eacbdecca9c9cda6"; 
    hash = "sha256-nXm664l84YSwZeRM4Hsweqgz+OlpyfwXcgEdyNGhaGA="; 
  };
in
{
  home.packages = with pkgs; [
    tmux
    tmuxinator
  ];

  xdg.configFile = {
    "tmux/tmux.conf".source = "${ohMyTmuxSrc}/.tmux.conf";

    "tmux/tmux.conf.local".text = ''

      tmux_conf_copy_to_os_clipboard=true 
      set -g @plugin 'tmux-plugins/tpm'

      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-continuum'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @resurrect-strategy-nvim 'session' 
      set -g @continuum-restore 'on' 
      set -g @continuum-save-interval '60'

      # set environment
      set-environment -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
      set -g status-keys vi
      set -g mode-keys vi

      run -b '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
