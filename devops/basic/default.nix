{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  packages = [
    pkgs.watchexec
  ];

  scripts.sync-6c-hk = {
    exec = ''
      watchexec -p -e nix -w ./ --shell=none -- \
        sync-6c-kr-on-change
    '';
  };
  scripts.sync-hn-hk = {
    exec = ''
      watchexec -p -e nix -w ./ --shell=none -- \
        sync-hn-hk-on-change
    '';
  };

  scripts.sync-hn-hk-on-change = {
    exec = ''
      treefmt && \
        rsync --delete -avzpP \
          --include='*/' \
          --include='*.nix' \
          --exclude='*' \
          ./ vps-data-hn-hk:~/.config/home-manager/
    '';
  };
  scripts.sync-6c-kr-on-change = {
    exec = ''
      treefmt && \
        rsync --delete -avzpP \
          --include='*/' \
          --include='*.nix' \
          --exclude='*' \
          ./ vps-data-6c-kr:~/.config/home-manager/
    '';
  };

  treefmt = {
    enable = true;
    config.settings.excludes = [
      "demo/*"
      "derivation/*"
      "flake/*"
      "module/*"
      "ncps/*"
      "old/*"
    ];
    config.programs.alejandra.enable = true;
  };
}
