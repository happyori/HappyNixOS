{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cursor-name = config.custom.hyprland.cursor-name;
  x-cursor-name = config.custom.hyprland.x-cursor-name;
  cursor-size = config.custom.hyprland.cursor-size;
in
{
  options.custom.hyprland = {
    cursor-name = mkOption {
      type = types.str;
      example = "material-cursor-light";
    };
    x-cursor-name = mkOption {
      type = types.str;
      default = config.custom.hyprland.cursor-name + "-x";
    };
    cursor-size = mkOption {
      type = types.int;
      default = 24;
    };
  };
  config = {
    wayland.windowManager.hyprland.settings = {
      env = [
        "QT_QPA_PLATFORM, wayland"
        "QT_QPA_PLATFORMTHEME, qt6ct"
        "XDG_SESSION_TYPE, wayland"
        "ELECTRON_OZONE_PLATFORM_HINT, wayland"

        #TODO: Make this an option
        "LIBVA_DRIVER_NAME, nvidia"
        "WLR_NO_HARDWARE_CURSORS, 1"
        "WLR_DRM_NO_ATOMIC, 1"
        "GBM_BACKEND, nvidia-drm"

        "HYPRCURSOR_THEME, ${cursor-name}"
        "HYPRCURSOR_SIZE, ${toString cursor-size}"
        "XCURSOR_THEME, ${x-cursor-name}"
        "XCURSOR_SIZE, ${toString cursor-size}"

        "SWWW_TRANSITION_FPS, 100"
        "SWWW_TRANSITION_DURATION, 4"
        "SWWW_TRANSITION_STEP, 80"
        "SWWW_TRANSITION, wipe"
        "SWWW_TRANSITION_ANGLE, 30"
      ];
    };
  };
}
