{
  config,
  pkgs,
  lib,
  ...
}: let
  forwardGpgAgent = pkgs.writeShellScript "forward-gpg-agent" ''
    set -eu
    umask 077
    forwarded_socket="$HOME/.gnupg/S.gpg-agent"
    [ -S "$forwarded_socket" ] || exit 0

    agent_socket=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-socket)
    [ -n "$agent_socket" ] || exit 0
    [ "$agent_socket" != "$forwarded_socket" ] || exit 0
    [ ! "$agent_socket" -ef "$forwarded_socket" ] || exit 0

    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$agent_socket")"
    # 锁文件保持存在，避免删除锁文件后不同进程锁住不同 inode。
    exec 9>"$agent_socket.forward.lock"
    ${pkgs.util-linux}/bin/flock -n 9 || exit 0

    # 其他 shell 可能已经完成接管，拿到锁后必须重新检查。
    [ -S "$forwarded_socket" ] || exit 0
    [ ! "$agent_socket" -ef "$forwarded_socket" ] || exit 0
    if [ -S "$agent_socket" ] && [ ! -L "$agent_socket" ]; then
      ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent
    fi

    # 不覆盖普通文件、目录，或停止失败后仍占据路径的本地 socket。
    if [ -L "$agent_socket" ] || [ ! -e "$agent_socket" ]; then
      ${pkgs.coreutils}/bin/ln -sfnT -- "$forwarded_socket" "$agent_socket"
    fi
  '';
in {
  xdg.configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";

  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    shellAbbrs = {
      hmb = "home-manager build";
      hms = "home-manager switch";
      hmgen = "home-manager generations";
      hmpkg = "home-manager packages";
    };

    # 1. 顶层配置：确保 Ansible 和管道脚本也能加载 Nix 路径
    shellInit = ''
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      end
    '';

    shellAliases = {
      mux = "tmuxinator";
      # cm = "chezmoi";

      hm = "home-manager";
      vim = "nvim";

      l = "ls -lhF --group-directories-first";
      ld = "eza -ld */ --no-quotes --time-style long-iso";
      lla = "eza -lah --no-quotes --time-style long-iso";
      ll = "eza -lh --no-quotes --time-style long-iso";
      llr = "eza -lhr --no-quotes --time-style long-iso";
      lls = "eza -lh -s size --no-quotes --time-style long-iso";
      llt = "eza -lh -s time --no-quotes --time-style long-iso";
      lltr = "eza -lhr -s time --no-quotes --time-style long-iso";
      # 3proxy log
      t3pl = "tail -f /var/log/3proxy/3proxy-$(date +%y%m%d).log";
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
      set -gx GPG_TTY (tty)


      # 仅接管有效 SSH agent；失败或未转发时保留原环境。
      begin
          set -l stable_socket "$HOME/.ssh/ssh_auth_sock"
          if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
              if test "$SSH_AUTH_SOCK" != "$stable_socket"
                  if test "$stable_socket" -ef "$SSH_AUTH_SOCK"
                      set -gx SSH_AUTH_SOCK "$stable_socket"
                  else if test -L "$stable_socket"; or not test -e "$stable_socket"
                      mkdir -p "$HOME/.ssh"
                      and ln -sfnT -- "$SSH_AUTH_SOCK" "$stable_socket"
                      and set -gx SSH_AUTH_SOCK "$stable_socket"
                  end
              end
          end
      end

      # 没有 GPG 转发时不启动辅助进程；修复过程在用户级锁内执行。
      if test -S "$HOME/.gnupg/S.gpg-agent"
          ${forwardGpgAgent}
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

    # Home Manager 会自动生成外层 function … end，这里应只写函数体。当前首次调用可能只是重新定义函数，没有执行预期操作。
    functions = {
      zv-tmux-kill-other = ''
        tmux list-windows  -a  -F '#{session_name}' | rg -v 'local' | sort -u | xargs -I xx tmux kill-session -t xx
      '';
    };
  };
}
