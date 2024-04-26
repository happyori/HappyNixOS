{ config, lib, ... }:
let
  monitors = config.custom.hyprland.monitors;
  inherit (lib) types mkOption;
in
{
  options.custom.hyprland = with types; {
    monitors = mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            example = "DP-1";
          };
          width = mkOption {
            type = int;
            example = 1920;
            default = 2560;
          };
          height = mkOption {
            type = int;
            example = 1080;
            default = 1440;
          };
          refresh = mkOption {
            type = number;
            example = 144;
            default = 60;
          };
          x = mkOption {
            type = int;
            example = 0;
            default = 0;
            description = "X offset from top left corner";
          };
          y = mkOption {
            type = int;
            example = 0;
            default = 0;
            description = "X offset from top left corner";
          };
          scale = mkOption {
            type = str;
            example = "auto";
            default = "auto";
          };
        };
      });
    };
  };

  config =
    let
      resolution = monitor: with monitor; "${toString width}x${toString height}@${toString refresh}";
      position = monitor: with monitor; "${toString x}x${toString y}";
      generateHyprMonitors = monitor: "${monitor.name},${resolution monitor},${position monitor},${toString monitor.scale}";
    in
    {
      wayland.windowManager.hyprland.settings = {
        monitor = map generateHyprMonitors monitors;
      };
    };
}
