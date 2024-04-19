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

  gtk.cursorTheme.name = "Bibata-Modern-Ice";
  gtk.cursorTheme.size = 24;
}
