{ pkgs
, config
, ...
}:
let
  theme = pkgs.orchis-theme.override {
    border-radius = 8;
  };
in
{
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "CascadiaCode" "JetBrainsMono" ]; })
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
    font = {
      package = pkgs.inter;
      size = 12;
      name = "Inter";
    };

    iconTheme.package = pkgs.beauty-line-icon-theme;
    iconTheme.name = "BeautyLine";
  };

  dconf = {
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  home.file.".local/share/themes/Orchis-Purple-Dark".source = config.lib.file.mkOutOfStoreSymlink "${theme}/share/themes/Orchis-Purple-Dark";
}
