{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/

  # https://devenv.sh/packages/
  packages = [
    pkgs.ags
    pkgs.webkitgtk
    pkgs.gtksourceview
    pkgs.accountsservice
    pkgs.dart-sass
    pkgs.fd
  ];


  # https://devenv.sh/languages/
  languages = {
    javascript = {
      enable = true;
      bun.enable = true;
      bun.install.enable = true;
    };
    typescript.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/

  enterShell = ''
    ags --init -c ./config.js
  '';

  scripts = {
    run.exec = ''ags -c ./config.js'';
    drun.exec = ''ags -c ./config.js -i'';
    dev.exec = ''neovide ./config.js'';
  };

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
