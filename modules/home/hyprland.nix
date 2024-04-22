{pkgs, ...}: let
  cursorTheme = import ../../extras/packages/hyprcursor/bibata.nix {inherit pkgs;};
  cursor_size = 24;
  cursor_name = "material-light-cursors";
in {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = cursor_name;
    XCURSOR_SIZE = builtins.toString cursor_size;
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

  gtk.cursorTheme.name = cursor_name;
  gtk.cursorTheme.size = cursor_size;
}
