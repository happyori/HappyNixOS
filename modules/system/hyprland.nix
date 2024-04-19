{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.sessions.hyprland;
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    sessions.hyprland.enable = mkEnableOption "Enables hyprland options";
  };
  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    environment.systemPackages = with pkgs; [
      wl-clipboard
      libva
      swaynotificationcenter
      qt6ct
      hyprshade
      hyprpicker
      hyprcursor
      swww
      ags
      spotify
      spicetify-cli
      qpwgraph
      pyprland
      gnome.nautilus
      rofi-wayland
    ];
  };
}
