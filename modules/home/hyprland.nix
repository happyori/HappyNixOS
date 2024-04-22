{pkgs, ...}: let
  cursorTheme = import ../../extras/packages/hyprcursor/bibata.nix {inherit pkgs;};
in {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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

  gtk.cursorTheme.name = "material-light-cursors";
  gtk.cursorTheme.size = 24;
}
