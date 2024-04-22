{pkgs, ...}: let
  icons = pkgs.callPackage ../../extras/packages/blue-accent-icons.nix {};
in {
  home.packages = [
    pkgs.inter
    pkgs.sassc
  ];

  gtk = {
    enable = true;
    # theme.package = pkgs.orchis-theme.override {
    #   border-radius = 8;
    # };
    # theme.name = "Orchis-theme";

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    iconTheme.package = icons;
    iconTheme.name = "Blue-Accent-Icons";
  };
}
