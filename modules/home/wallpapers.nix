{ lib, config, ... }:
{
  options.custom.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "Relative path to the wallpaper";
  };

  # options = let inherit (lib) mkOption mkEnableOption types; in {
  #   custom.wallpaper = mkOption {
  #     type = either path <| submodule { };
  #   };
  # };
  #
  config = {
    xdg.configFile."swww/wallpaper".source = config.custom.wallpaper;
  };
}
