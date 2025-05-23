{
  lib,
  config,
  pkgs,
  custom-options,
  paths,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.utils;
  zen = import (paths.custom_pkgs + /zen.nix) { inherit pkgs; };
in
{
  options.custom.utils = {
    zoxide.enable = mkEnableOption "Enable zoxide integration";
    ssh.enable = mkEnableOption "Enable ssh integration";
  };
  config = {
    programs.zoxide = {
      inherit (cfg.zoxide) enable;
      enableNushellIntegration = config.custom.shells.nushell.enable;
    };

    programs.ssh = {
      inherit (cfg.ssh) enable;
      extraConfig = mkIf custom-options._1password.enable ''
        Host *
        	IdentityAgent ~/.1password/agent.sock
      '';
    };

    services.blueman-applet.enable = true;
    home.packages = [
      pkgs.btop
      pkgs.audacity
      pkgs.bat
      pkgs.vivaldi
      pkgs.nix-tree
      pkgs.obsidian
      pkgs.blueman
      pkgs.qpdfview
      pkgs.loupe
      pkgs.via
      pkgs.vlc
      zen
    ];
  };
}
