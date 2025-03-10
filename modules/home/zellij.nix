{
  pkgs,
  paths,
  config,
  ...
}:
let
  path = paths.custom_pkgs + "/modus-theme.nix";
  modus_der = import path { inherit pkgs; };
  theme = "${modus_der}/themes/extras/zellij/modus_vivendi.kdl";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = { };
  };

  xdg.configFile."zellij/config.kdl" = {
    source = mkOutOfStoreSymlink (paths.app_configs + "/zellij/config.kdl");
  };

  xdg.configFile."zellij/themes/modus_vivendi.kdl" = {
    source = theme;
  };
}
