{ ... }:
{
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
      "WLR_RENDERER_ALLOW_SOFTWARE, 1"
      "GBM_BACKEND, nvidia-drm"

      "SWWW_TRANSITION_FPS, 100"
      "SWWW_TRANSITION_DURATION, 4"
      "SWWW_TRANSITION_STEP, 80"
      "SWWW_TRANSITION, wipe"
      "SWWW_TRANSITION_ANGLE, 30"
    ];
  };
}
