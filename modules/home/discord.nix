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
    withVencord = mkEnableOption "Enable discord + vencord configuration";
    withVesktop = mkEnableOption "Use vesktop client instead of normal discord client";
  };

  config = mkIf cfg.enable {
    home.packages = let
      package =
        if cfg.withVesktop
        then
          pkgs.vesktop.override {
            withSystemVencord = cfg.withVencord;
          }
        else if cfg.withVencord
        then
          pkgs.discord.override {
            withVencord = true;
          }
        else pkgs.discord;
    in
      lib.optional cfg.withVencord pkgs.vencord ++ [package];
  };
}
