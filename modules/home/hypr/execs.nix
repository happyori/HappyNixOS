{ config, lib, ... }:
let
  execs = config.custom.hyprland.execs;
  inherit (lib) types mkOption;
in
{
  options.custom.hyprland.execs = with types; mkOption {
    type = listOf (either
      (submodule {
        options = {
          once = mkOption {
            type = bool;
            default = true;
          };
          cmd = mkOption {
            type = str;
            example = "wl-paste --type text --watch cliphist store";
          };
          rule = mkOption {
            type = nullOr str;
            default = null;
            example = "workspace name:web silent";
          };
        };
      })
      str);
    example = "swaync";
  };

  config =
    let
      construct = cmd: { inherit cmd; once = true; rule = null; };
      mapped = map (v: if builtins.isString v then construct v else v) execs;
      key = exec: if exec.once then "exec-once" else "exec";
      rule = exec: if exec.rule == null then "" else "[${exec.rule}] ";
      execGenerator = exec: {
        ${key exec} = "${rule exec}${exec.cmd}";
      };
      settingsGenerator = sets: lib.foldAttrs (n: a: [ n ] ++ a) [ ] sets;
    in
    {
      wayland.windowManager.hyprland.settings = settingsGenerator (map execGenerator mapped);
    };
}
