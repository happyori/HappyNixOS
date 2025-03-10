{ config, lib, ... }:
let
  nvidia-cfg = config.custom.hardware.nvidia.enable;
  env_attrs = config.custom.hypr.env;
  toHyprEnv = name: val: "${name}, ${val}";
in
{
  options.custom.hypr.env = lib.mkOption {
    type = lib.types.attrs;
    visible = false;
    internal = true;
  };
  config = {
    custom.hypr.env =
      {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        XDG_SESSION_TYPE = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        SWWW_TRANSITION_FPS = "100";
        SWWW_TRANSITION_DURATION = "4";
        SWWW_TRANSITION_STEP = "80";
        SWWW_TRANSITION = "wipe";
        SWWW_TRANSITION_ANGLE = "30";
      }
      // lib.optionalAttrs nvidia-cfg {
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_DRM_NO_ATOMIC = "1";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      }
      // config.home.sessionVariables;
    wayland.windowManager.hyprland.settings.env = lib.mapAttrsToList toHyprEnv env_attrs;
  };
}
