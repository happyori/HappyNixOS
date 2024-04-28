{ system
, inputs
, config
, lib
, pkgs
, ...
}:
let
  cursor-size = 24;
  cursor-name = "material_light_cursors";
in
{
  imports = [
    ./hypr/monitors.nix
    ./hypr/execs.nix
    ./hypr/rules.nix
    ./hypr/keybinds.nix
    ./hypr/environment.nix
    ./hypr/extras.nix
    ./hypr/general.nix
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = cursor-name;
    XCURSOR_SIZE = (toString cursor-size);
    HYPRCURSOR_THEME = cursor-name + "-hypr";
    HYPRCURSOR_SIZE = (toString cursor-size);
  };

  custom.hyprland = {
    monitors = [
      {
        name = "HDMI-A-1";
        width = 2560;
        height = 1440;
        refresh = 143.97;
        x = 0;
        y = 0;
        scale = "auto";
      }
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        refresh = 169.83;
        x = -2560;
        y = 0;
        scale = "auto";
      }
    ];
    rules = {
      workspaces = [
        {
          workspace = "name:web";
          rules = [ "gapsin:4" "gapsout:4" "monitor:DP-1" "default:true" "borderside:1" "shadow:false" ];
        }
        {
          workspace = "name:discord";
          rules = [ "gapsin:2" "gapsout:2" "shadow:false" "borderside:1" ];
        }
      ];
      windows = [
        {
          matches = [ "class:.*" ];
          rules = [ "suppressevent maximize" ];
        }
        {
          matches = [ "class:IconLibrary$" ];
          rules = [ "float" "size 650 600" ];
        }
        {
          matches = [ "class:vesktop$" ];
          rules = [ "workspace name:discord silent" ];
        }
      ];
      layers = [
        {
          match = "happy_bar_*";
          rules = [ "blur" "ignorezero" ];
        }
      ];
    };
    keybinds =
      let
        mainMod = "ALT";
        # TODO: Make these variables an option of pkgs to set (use lib.getExe)
        terminal = "kitty";
        fileManager = "nautilus";
        menu = "rofi -show drun";

        defaultKeybindMod = key: { dispatcher ? "exec", args ? null, flags ? null }: {
          mods = [ mainMod ];
          inherit key dispatcher args flags;
        };
        defaultMotions = dispatcher: mods:
          let
            hjkl = [ "H" "J" "K" "L" ];
            motions = [ "l" "d" "u" "r" ];
            zipped = lib.zipLists hjkl motions;
          in
          map
            (s: {
              inherit mods dispatcher;
              key = s.fst;
              args = [ s.snd ];
            })
            zipped;
        defaultWorkspaceKeybinds = range:
          map (i: { mods = [ mainMod ]; key = toString i; args = [ (toString i) ]; dispatcher = "workspace"; }) range
          ++ map (i: { mods = [ mainMod "SHIFT" ]; key = toString i; args = [ (toString i) ]; dispatcher = "movetoworkspace"; }) range;
        defaultResizingBinds = mods:
          let
            motions = [ "left" "right" "up" "down" ];
            args = [ [ (-10) 0 ] [ 10 0 ] [ 0 (-10) ] [ 0 10 ] ];
            zipped = lib.zipLists motions args;
          in
          map (s: { inherit mods; flags = [ "e" ]; key = s.fst; args = s.snd; dispatcher = "resizeactive"; }) zipped;
      in
      lib.flatten [
        (defaultKeybindMod "Q" { args = [ terminal ]; })
        (defaultKeybindMod "C" { dispatcher = "killactive"; })
        (defaultKeybindMod "M" { dispatcher = "exit"; })
        (defaultKeybindMod "E" { args = [ fileManager ]; })
        (defaultKeybindMod "V" { dispatcher = "togglefloating"; })
        (defaultKeybindMod "R" { args = [ menu ]; })
        (defaultKeybindMod "P" { dispatcher = "pseudo"; })
        (defaultKeybindMod "U" { dispatcher = "togglesplit"; })
        (defaultKeybindMod "X" { args = [ "cliphist list |" "rofi -dmenu |" "cliphist decode |" "wl-copy" ]; })
        (defaultKeybindMod "F" { dispatcher = "fullscreen"; args = [ 1 ]; })
        {
          mods = [ mainMod "CTRL" ];
          key = "W";
          dispatcher = "exec";
          args = [ "ags -q;" "mkdir -p /tmp/ags/;" "ags &> /tmp/ags/log" ];
        }
        {
          mods = [ mainMod "CTRL" ];
          key = "C";
          dispatcher = "exec";
          args = [ "hyprpicker" "-a" "-f" "hex" ];
        }
        # Workspace keybinds

        (defaultResizingBinds [ mainMod "CTRL" ])

        (defaultMotions "movefocus" [ mainMod ])
        (defaultMotions "swapwindow" [ mainMod "SHIFT" ])
        (defaultWorkspaceKeybinds (lib.range 1 5))

        (defaultKeybindMod "B" { dispatcher = "workspace"; args = [ "name:web" ]; })
        (defaultKeybindMod "S" { dispatcher = "workspace"; args = [ "name:music" ]; })
        (defaultKeybindMod "D" { dispatcher = "workspace"; args = [ "name:discord" ]; })

        (defaultKeybindMod "grave" { args = [ "pypr" "toggle" "term" ]; })
        (defaultKeybindMod "mouse_down" { dispatcher = "workspace"; args = [ "e+1" ]; })
        (defaultKeybindMod "mouse_up" { dispatcher = "workspace"; args = [ "e-1" ]; })
        (defaultKeybindMod "mouse:272" { dispatcher = "movewindow"; flags = [ "m" ]; args = [ ]; })
        (defaultKeybindMod "mouse:273" { dispatcher = "resizewindow"; flags = [ "m" ]; args = [ ]; })
      ];
    execs = [
      "mkdir -p /tmp/ags; mkdir -p /tmp/happy"
      "swaync"
      "1password --silent &>> /tmp/happy/1password.log"
      "blueman-applet"
      "swww-daemon"
      "pypr"
      "ags &>> /tmp/ags/log"
      "qpwgraph -max ${config.xdg.configHome}/qpwgraph/patchbay.qpwgraph &>> /tmp/happy/qpwgraph.log"
      { rule = "workspace name:web silent"; cmd = "vivaldi"; }
      { rule = "workspace name:music silent"; cmd = "spotify"; }
      { rule = "workspace name:discord silent"; cmd = "vesktop"; }
      "nu ~/Scripts/hypr/launch_gnome_polkit.nu"
      "~/Scripts/hypr/auto-connect"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "wl-clip-persist --clipboard regular"
      "swww img ${config.xdg.configHome}/swww/wallpaper"
      "dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
      { once = false; cmd = "hyprshade auto"; }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;
  };

  home.pointerCursor =
    {
      gtk.enable = true;
      name = cursor-name;
      size = cursor-size;
      package = pkgs.material-cursors;
    };

  gtk.cursorTheme.name = cursor-name;
  gtk.cursorTheme.size = cursor-size;
  gtk.cursorTheme.package = pkgs.material-cursors;
}
