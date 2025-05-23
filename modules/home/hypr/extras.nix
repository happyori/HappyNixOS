{ pkgs, paths, ... }:
let
  hypr-config = p: paths.app_configs + "/hyprland" + p;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      wl-clipboard
      clipse
      wl-clip-persist
      libva
      swaynotificationcenter
      qt6ct
      hyprshade
      hyprpicker
      hyprcursor
      swww
      ags
      # TODO: move spotify stuff out of here
      spotify
      spicetify-cli
      qpwgraph
      rofi-wayland
      grim
      slurp
      nautilus
      pyprland
      libdbusmenu-gtk3
      ;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
  xdg.portal.config = {
    hyprland = {
      default = "hyprland;gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
  };

  xdg.configFile."qpwgraph/patchbay.qpwgraph".source = paths.app_configs + "/Patchbay.qpwgraph";
  xdg.configFile."hypr/shaders".source = hypr-config /shaders;
  xdg.configFile."hypr/hyprshade.toml".source = hypr-config /hyprshade.toml;
  xdg.configFile."hypr/pyprland.toml".source = hypr-config /pyprland.toml;
}
