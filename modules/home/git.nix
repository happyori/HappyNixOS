{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.git;
in {
  options = {
    git.with_lazygit = mkEnableOption "Adds lazy git configurations";
  };

  config = {
    programs.lazygit.enable = cfg.with_lazygit;
    programs.git = {
      enable = true;
      ignores = ["*.root" "*.swap"];
      userEmail = "orkhan.tahirov@gmail.com";
      userName = "happyori";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
