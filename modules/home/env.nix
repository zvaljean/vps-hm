{
  config,
  pkgs,
  ...
}: {
  home.file = {
    # 加入sops-nix后，第一次执行会出现oom
    ".config/nix/nix.conf".text = ''
      max-jobs = 1
      cores = 1
      max-substitution-jobs = 1
      http-connections = 4
    '';
  };

  home.sessionVariables = {
    PAGER = "less";
    LC_TIME = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "UTF-8";
    GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
    LANG = "en_US.UTF-8";
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIX_REMOTE = "daemon";
    # TERM = "xterm-256color";
  };
}
