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
          l = "ls -la";
          ll = "ls -la --absolute=on";
          lld = "duf";
          gs = "git status";
        };
        shellAliases = {
          ls = "eza --git --smart-group --group-directories-first";
        };
      };
      programs.direnv.enableFishIntegration = true;
      programs.eza.enableFishIntegration = false;
    };
}
