{ pkgs, paths, ... }:
let
  path = paths.custom_pkgs + "/modus_vivendi.nix";
  modus_der = import path { inherit pkgs; };
  theme = "${modus_der}/themes/extras/zellij/modus_vivendi.kdl";
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
