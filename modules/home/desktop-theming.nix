{pkgs, ...}: let
  icons = pkgs.callPackage ../../extras/packages/blue-accent-icons.nix {};
in {
  home.packages = [
    pkgs.inter
  ];
  gtk.theme.package = pkgs.orchis-theme.override {
    border-radius = 8;
    tweaks = ["dracula"];
  };
  gtk.theme.name = "Orchis-theme";
  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  gtk.iconTheme.package = icons;
  gtk.iconTheme.name = "Blue-Accent-Icons";
}
