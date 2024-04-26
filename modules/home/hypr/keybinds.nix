{ config, lib, ... }:
let
  keybinds = config.custom.hyprland.keybinds;
  inherit (lib) types mkOption;
in
{
  options.custom.hyprland.keybinds = with types; mkOption {
    type = listOf (submodule {
      options = {
        mods = mkOption {
          type = nullOr (listOf str);
          example = [ "Super" "Shift" ];
        };
        key = mkOption {
          type = str;
          example = "Q";
        };
        dispatcher = mkOption {
          type = str;
          example = "exec";
        };
        args = mkOption {
          type = nullOr (listOf anything);
          example = [ "name:discord" ];
          default = null;
        };
        flags = mkOption {
          type = nullOr (listOf (strMatching "l|r|e|n|m|t|i"));
          example = [ "r" "e" ];
          default = null;
        };
        unbind = mkOption {
          type = bool;
          example = false;
          default = false;
        };
      };
    });
  };

  config =
    let
      generateFlags = flags: if flags != null then lib.concatStringsSep "" flags else "";
      generateArgs = args: if args == [ ] then "" else ", ${toString args}";
      generateBindings = keybind:
        if keybind.unbind then {
          unbind = "${toString keybind.mods}, ${keybind.key}";
        } else {
          "bind${generateFlags keybind.flags}" = "${toString keybind.mods}, ${keybind.key}, ${keybind.dispatcher}${generateArgs keybind.args}";
        };
      generateSettings = sets: lib.foldAttrs (n: a: [ n ] ++ a) [ ] sets;
    in
    {
      wayland.windowManager.hyprland.settings = generateSettings (map generateBindings keybinds);
    };
}
