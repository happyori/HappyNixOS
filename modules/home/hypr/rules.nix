{ config, lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.custom.hyprland.rules = with types; {
    workspaces = mkOption
      {
        type = listOf (submodule {
          options = {
            rules = mkOption {
              type = listOf str;
              example = [ "gasin:4" "gapsout:4" "monitor:DP-1" ];
            };
            workspace = mkOption {
              type = either str int;
              example = "name:web";
            };
          };
        });
      };
    windows = mkOption {
      type = listOf (submodule {
        options = {
          version = mkOption {
            type = ints.between 1 2;
            example = 2;
            default = 2;
          };
          matches = mkOption {
            type = listOf str;
            example = [ "^(kitty)$" "title:^(Firefox)(.*)$" ];
          };
          rules = mkOption {
            type = listOf str;
            example = [ "workspace name:discord silent" "float" "size 650 600" ];
          };
        };
      });
    };
    layers = mkOption {
      type = listOf (submodule {
        options = {
          rules = mkOption {
            type = listOf str;
            example = [ "blur" "ignorezero" ];
          };
          match = mkOption {
            type = str;
            example = "address:0x12345678 or regex";
          };
        };
      });
    };
  };
  config =
    let
      cfg = config.custom.hyprland.rules;
      inherit (builtins) flatten filter;

      generateWindowRulesV1 = window: flatten (
        map (rule: map (match: "${rule},${match}") window.matches) window.rules
      );
      generateWindowRulesV2 = window: map (rule: "${rule},${lib.concatStringsSep "," window.matches}") window.rules;
      generateWorkspaceRules = ws: "${ws.workspace},${lib.concatStringsSep "," ws.rules}";
      generateLayerRules = l: map (rule: "${rule}, ${l.match}") l.rules;

      windowsV1 = filter (w: w.version == 1) cfg.windows;
      windowsV2 = filter (w: w.version == 2) cfg.windows;
    in
    {
      wayland.windowManager.hyprland.settings = {
        windowrule = lib.concatMap generateWindowRulesV1 windowsV1;
        windowrulev2 = lib.concatMap generateWindowRulesV2 windowsV2;
        layerrule = lib.concatMap generateLayerRules cfg.layers;
        workspace = map generateWorkspaceRules cfg.workspaces;
      };
    };
}
