{ pkgs, paths, ... }:
let
  modus = import paths.custom_pkgs.modus-theme { inherit pkgs; };
  theme = "${modus.out}/themes/extras/zellij/modus_vivendi.kdl";
in
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "modus_vivendi";
    };
  };

  xdg.configFile."zellij/themes/modus_vivendi.kdl" = {
    source = theme;
  };
}
