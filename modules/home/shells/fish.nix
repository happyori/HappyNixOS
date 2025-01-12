{ config
, lib
, ...
}:
{
  options.custom.shells.fish =
    let inherit (lib) mkEnableOption; in {
      enable = mkEnableOption "Enable fish integration";
    };
  config =
    let cfg = config.custom.shells.fish; in lib.mkIf cfg.enable {
      programs.fish = {
        enable = true;
        generateCompletions = true;
        preferAbbrs = true;
        shellAbbrs = {
          lz = "lazygit";
          l = "ls -lah --no-time --no-permissions --no-time --no-user";
          ll = "ls -lah --absolute=on";
          lla = "ls -lah";
          lld = "duf";
          gs = "git status";
        };
        shellAliases = {
          ls = "eza --icons always --color always --git --smart-group --group-directories-first";
        };
      };
      programs.direnv.enableFishIntegration = true;
      programs.eza.enableFishIntegration = false;
    };
}
