{ pkgs, paths, ... }:
let
  hypr-config = p: paths.app_configs + "/hyprland" + p;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
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
      rofi-wayland
      grim
      slurp
      libdbusmenu-gtk3;
    nautilus = pkgs.gnome.nautilus;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
  ];
  xdg.portal.config = {
    hyprland = {
      default = "hyprland;gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gnome";
    };
  };

  xdg.configFile."hypr/shaders".source = hypr-config /shaders;
  xdg.configFile."hypr/hyprshade.toml".source = hypr-config /hyprshade.toml;
  xdg.configFile."hypr/pyprland.toml".source = hypr-config /pyprland.toml;
}
