{
  pkgs,
  config,
  ...
}: let
  icons = pkgs.callPackage ../../extras/packages/blue-accent-icons.nix {};
  theme = pkgs.orchis-theme.override {
    border-radius = 8;
  };
in {
  home.packages = [
    pkgs.inter
  ];

  gtk = {
    enable = true;
    theme.package = theme;
    theme.name = "Orchis-Purple-Dark";

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    iconTheme.package = icons;
    iconTheme.name = "Blue-Accent-Icons";
  };

  home.file.".local/share/icons/Blue-Accent-Icons".source = config.lib.file.mkOutOfStoreSymlink icons;
  home.file.".local/share/themes/Orchis-Purple-Dark".source = config.lib.file.mkOutOfStoreSymlink "${theme}/share/themes/Orchis-Purple-Dark";
}
