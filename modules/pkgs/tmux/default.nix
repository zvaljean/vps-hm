{
  config,
  pkgs,
  lib,
  ...
}: let
  ohMyTmuxSrc = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "af33f07134b76134acca9d01eacbdecca9c9cda6";
    hash = "sha256-nXm664l84YSwZeRM4Hsweqgz+OlpyfwXcgEdyNGhaGA=";
  };

  # 回移上游版本列表，允许稳定版 tmuxinator 识别 tmux 3.7b。
  tmuxinatorPkgs = pkgs.tmuxinator.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        substituteInPlace \
          "$GEM_HOME/gems/tmuxinator-${old.version}/lib/tmuxinator/tmux_version.rb" \
          --replace-fail \
          '"3.6a",' \
          '"3.7b", "3.7a", 3.7, "3.6b", "3.6a",'
      '';
  });
in {
  options.tmux.enable = lib.mkEnableOption "tmux config trigger.";

  config = lib.mkIf config.tmux.enable {
    home.packages = [tmuxinatorPkgs pkgs.tmux];
    xdg.configFile = {
      "tmux/tmux.conf".source = "${ohMyTmuxSrc}/.tmux.conf";
      "fish/completions/tmuxinator.fish".source = "${tmuxinatorPkgs}/share/fish/vendor_completions.d/tmuxinator.fish";
    };
  };
}
