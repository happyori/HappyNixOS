{
  pkgs,
  config,
  ...
}: let
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

    iconTheme.package = pkgs.beauty-line-icon-theme;
    iconTheme.name = "BeautyLineSimple";
  };

  home.file.".local/share/themes/Orchis-Purple-Dark".source = config.lib.file.mkOutOfStoreSymlink "${theme}/share/themes/Orchis-Purple-Dark";
}
