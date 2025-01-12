{ pkgs
, config
, lib
, ...
}:
let
  cfg = config.custom.shells.murex;
  configHome = config.xdg.configHome;
  murexConfig = "${configHome}/murex/";
  inherit (lib) mkEnableOption optionalAttrs mkIf;
in
{
  options.custom.shells.murex = {
    enable = mkEnableOption "Enable murex setup";
    enableStarship = mkEnableOption "Enables the starship config" // { default = true; };
    modules = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Murex Modules to load";
      default = [ ];
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.murex ] ++ cfg.modules;
    home.sessionVariables = optionalAttrs config.home.preferXdgDirectories {
      MUREX_PRELOAD = murexConfig;
      MUREX_MODULES = murexConfig + "modules/";
      MUREX_PROFILE = murexConfig;
    };

    xdg.configFile."murex/.murex_profile".text =
      let
        concatNewLines = lib.concatStringsSep "\n";
        toMurexPackage = pkg: "murex-package import ${pkg}/package.json <null>";
        murex-pkgs = map toMurexPackage cfg.modules;
      in
      concatNewLines (murex-pkgs ++ [
        "alias eza=eza --git --smart-group --group-directories-first"
        "alias l=eza -la"
        "alias ll=eza -la --absolute=on"
        "alias lld=duf"
      ]);
    custom.shells.enableStarshipIntegration = true;
  };
}
