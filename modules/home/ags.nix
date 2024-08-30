{ inputs, pkgs, paths, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = paths.app_configs + "ags";

    extraPackages = [
      pkgs.gtksourceview
      pkgs.webkitgtk
      pkgs.accountsservice
      pkgs.bun
    ];
  };
}
