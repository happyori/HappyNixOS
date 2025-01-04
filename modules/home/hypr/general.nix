_:
{
  config = {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = "no";
        };
        sensitivity = 0;
      };

      cursor = {
        no_hardware_cursors = 2;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 20;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          xray = false;
          vibrancy = 0.4;
          special = true;
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          offset = "0, 6";
          color = "rgba(1a1a1a5a)";
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      gestures = {
        workspace_swipe = "off";
      };

      misc = {
        force_default_wallpaper = 0;
        animate_mouse_windowdragging = true;
        animate_manual_resizes = true;
      };

      debug = {
        disable_logs = false;
      };

      "plugin:dynamic-cursors" = {
        enabled = true;
        mode = "tilt";
        threshold = 2;

        tilt = {
          limit = 7000;
        };
      };
    };
  };
}
