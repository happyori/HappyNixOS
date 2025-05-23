{
  lib,
  config,
  pkgs,
  paths,
  ...
}:
let
  cfg = config.greeter;
  inherit (lib) mkIf mkEnableOption;
  theme = import (paths.custom_pkgs + /sddm-astronaut-theme.nix) {
    inherit pkgs;
  };
in
{
  options.greeter.sddm = {
    enable = mkEnableOption "Enable sddm greeter";
    wayland.enable = mkEnableOption "Enable wayland sddm";
  };

  config = mkIf cfg.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = cfg.sddm.wayland.enable;
      theme = "Astronaut";
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        pkgs.qt6.qt5compat
      ];
      autoNumlock = true;
    };
    services.xserver.displayManager.setupCommands = "xrandr --output HDMI-A-1 --off --output DP-2 --primary";

    environment.systemPackages = with pkgs; [
      qt6.qt5compat
      qt6.qtdeclarative
      qt6.qtsvg
      qt5.qtgraphicaleffects
      theme
    ];
  };
}
