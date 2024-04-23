{
  pkgs,
  paths,
  ...
}: let
  cursorTheme = import (paths.custom_pkgs + /hyprcursor/bibata.nix) {inherit pkgs;};
  cursor_size = 24;
  cursor_name = "material-light-cursors";
in {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = cursor_name + "-x";
    XCURSOR_SIZE = builtins.toString cursor_size;
    # Hyprland loads cursors before home manager sets these env vars; Until hyprland config is not moved to home manager these in the essense do nothing;
    HYPRCURSOR_THEME = cursor_name;
    HYPRCURSOR_SIZE = builtins.toString cursor_size;
  };

  home.file.".local/share/icons/Bibata-Modern-Ice" = {
    enable = true;
    source = "${cursorTheme}";
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

  home.packages = [
    pkgs.grim
    pkgs.slurp
  ];

  gtk.cursorTheme.name = cursor_name + "-x";
  gtk.cursorTheme.size = cursor_size;
}
