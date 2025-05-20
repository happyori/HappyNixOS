{
  system,
  inputs,
  config,
  lib,
  pkgs,
  ...
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
    XCURSOR_SIZE = toString cursor-size;
    HYPRCURSOR_THEME = cursor-name + "-hypr";
    HYPRCURSOR_SIZE = toString cursor-size;
  };

  custom.hyprland = {
    rules = {
      workspaces = [
        {
          workspace = "name:web";
          rules = [
            "gapsin:4"
            "gapsout:4"
            # TODO: Make the Display identified by monitor rather then by connector
            "monitor:DP-1"
            "default:true"
            "borderside:1"
            "shadow:false"
          ];
        }
        {
          workspace = "name:discord";
          rules = [
            "gapsin:2"
            "gapsout:2"
            "shadow:false"
            "borderside:1"
          ];
        }
      ];
      windows = [
        {
          matches = [ "class:.*" ];
          rules = [ "suppressevent maximize" ];
        }
        {
          matches = [ "class:IconLibrary$" ];
          rules = [
            "float"
            "size 650 600"
          ];
        }
        {
          matches = [ "class:vesktop$" ];
          rules = [ "workspace name:discord silent" ];
        }
        {
          matches = [
            "tag:games"
            "fullscreen:1"
          ];
          rules = [ "immediate" ];
        }
        {
          matches = [ "class:^(Minecraft)" ];
          rules = [
            "tag +games"
            "workspace emptym"
          ];
        }
      ];
      layers = [
        {
          match = "happy_bar_*";
          rules = [
            "blur"
            "ignorezero"
          ];
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

        defaultKeybindMod =
          key:
          {
            dispatcher ? "exec",
            args ? null,
            flags ? null,
          }:
          {
            mods = [ mainMod ];
            inherit
              key
              dispatcher
              args
              flags
              ;
          };
        defaultMotions =
          dispatcher: mods:
          let
            hjkl = [
              "H"
              "J"
              "K"
              "L"
            ];
            motions = [
              "l"
              "d"
              "u"
              "r"
            ];
            zipped = lib.zipLists hjkl motions;
          in
          map (s: {
            inherit mods dispatcher;
            key = s.fst;
            args = [ s.snd ];
          }) zipped;
        defaultWorkspaceKeybinds =
          range:
          map (i: {
            mods = [ mainMod ];
            key = toString i;
            args = [ (toString i) ];
            dispatcher = "workspace";
          }) range
          ++ map (i: {
            mods = [
              mainMod
              "SHIFT"
            ];
            key = toString i;
            args = [ (toString i) ];
            dispatcher = "movetoworkspace";
          }) range;
        defaultResizingBinds =
          mods:
          let
            motions = [
              "left"
              "right"
              "up"
              "down"
            ];
            args = [
              [
                (-10)
                0
              ]
              [
                10
                0
              ]
              [
                0
                (-10)
              ]
              [
                0
                10
              ]
            ];
            zipped = lib.zipLists motions args;
          in
          map (s: {
            inherit mods;
            flags = [ "e" ];
            key = s.fst;
            args = s.snd;
            dispatcher = "resizeactive";
          }) zipped;
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
        (defaultKeybindMod "F" {
          dispatcher = "fullscreen";
          args = [ 1 ];
        })
        {
          mods = [
            mainMod
            "SHIFT"
          ];
          key = "F";
          dispatcher = "fullscreen";
          args = [ 0 ];
        }
        {
          mods = [ "SUPER" ];
          key = "V";
          dispatcher = "exec";
          args = [ "nu ~/Scripts/toggle_clipse.nu" ];
        }
        {
          mods = [
            mainMod
            "CTRL"
          ];
          key = "W";
          dispatcher = "exec";
          args = [
            "ags -q;"
            "mkdir -p /tmp/ags/;"
            "ags &> /tmp/ags/log"
          ];
        }
        {
          mods = [
            mainMod
            "CTRL"
          ];
          key = "C";
          dispatcher = "exec";
          args = [
            "hyprpicker"
            "-a"
            "-f"
            "hex"
          ];
        }
        # Workspace keybinds

        (defaultResizingBinds [
          mainMod
          "CTRL"
        ])

        (defaultMotions "movefocus" [ mainMod ])
        (defaultMotions "swapwindow" [
          mainMod
          "SHIFT"
        ])
        (defaultWorkspaceKeybinds (lib.range 1 5))

        (defaultKeybindMod "B" {
          dispatcher = "workspace";
          args = [ "name:web" ];
        })
        (defaultKeybindMod "S" {
          dispatcher = "workspace";
          args = [ "name:music" ];
        })
        (defaultKeybindMod "D" {
          dispatcher = "workspace";
          args = [ "name:discord" ];
        })

        (defaultKeybindMod "grave" {
          args = [
            "pypr"
            "toggle"
            "term"
          ];
        })
        (defaultKeybindMod "mouse_down" {
          dispatcher = "workspace";
          args = [ "e+1" ];
        })
        (defaultKeybindMod "mouse_up" {
          dispatcher = "workspace";
          args = [ "e-1" ];
        })
        (defaultKeybindMod "mouse:272" {
          dispatcher = "movewindow";
          flags = [ "m" ];
          args = [ ];
        })
        (defaultKeybindMod "mouse:273" {
          dispatcher = "resizewindow";
          flags = [ "m" ];
          args = [ ];
        })
      ];
    execs = [
      "mkdir -p /tmp/ags; mkdir -p /tmp/happy"
      "swaync"
      "1password --silent &>> /tmp/happy/1password.log"
      "blueman-applet"
      "swww-daemon"
      "pypr"
      # "ags &>> /tmp/ags/log" removed untill setup is complete (pending forever)
      "qpwgraph -max ${config.xdg.configHome}/qpwgraph/patchbay.qpwgraph &>> /tmp/happy/qpwgraph.log"
      {
        rule = "workspace name:web silent";
        cmd = "zen-browser";
      }
      {
        rule = "workspace name:music silent";
        cmd = "spotify";
      }
      {
        rule = "workspace name:discord silent";
        cmd = "vesktop --ozone-platform-hint=x11";
      }
      "nu ~/Scripts/launch_gnome_polkit.nu"
      "~/Scripts/hypr/auto-connect"
      "wl-clip-persist --clipboard primary"
      "clipse -listen"
      "~/.config/swww/activation"
      "dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
      "sleep 2; hyprshade auto"
      {
        once = false;
        cmd = "hyprshade auto";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = cursor-name;
    size = cursor-size;
    package = pkgs.material-cursors;
  };

  gtk.cursorTheme.name = cursor-name;
  gtk.cursorTheme.size = cursor-size;
  gtk.cursorTheme.package = pkgs.material-cursors;
}
