{ lib, config, ... }:
{
  options.custom.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "Relative path to the wallpaper";
  };

  config = {
    xdg.configFile."swww/wallpaper".source = config.custom.wallpaper;
  };
}
