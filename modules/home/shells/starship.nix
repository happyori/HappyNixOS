{ config, lib, ... }:
let
  cfg = config.custom.shells;
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  options.custom.shells.enableStarshipIntegration = lib.mkEnableOption "Enables the starship setup";
  config = mkIf cfg.enableStarshipIntegration {
    programs.starship = {
      enable = true;
      enableFishIntegration = cfg.fish.enable;
      enableNushellIntegration = cfg.nushell.enable;
      settings = { };
    };

    xdg.configFile."starship.toml" = {
      source = mkOutOfStoreSymlink (
        config.xdg.configHome + "/nixos/extras/configs/starship/starship.toml"
      );
    };
  };
}
