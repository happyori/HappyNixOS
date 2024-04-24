{
  lib,
  config,
  pkgs,
  custom-options,
  paths,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.utils;
  lychee = pkgs.callPackage (paths.custom_pkgs + /lychee.nix) {};
in {
  options.custom.utils = {
    zoxide.enable = mkEnableOption "Enable zoxide integration";
    ssh.enable = mkEnableOption "Enable ssh integration";
  };
  config = {
    programs.zoxide = {
      enable = cfg.zoxide.enable;
      enableNushellIntegration = config.custom.shells.nushell.enable;
    };

    programs.ssh = {
      enable = cfg.ssh.enable;
      extraConfig = mkIf custom-options._1password.enable ''
        Host *
        	IdentityAgent ~/.1password/agent.sock
      '';
    };

    services.blueman-applet.enable = true;
    home.packages = [
      pkgs.btop
      pkgs.bat
      pkgs.vivaldi
      pkgs.nix-tree
      pkgs.cura
      pkgs.freecad
      lychee
    ];
  };
}
