{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.discord;
in {
  options.discord = {
    enable = mkEnableOption "Enable discord all together";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.discord.override {
        withVencord = true;
      })
    ];
  };
}
