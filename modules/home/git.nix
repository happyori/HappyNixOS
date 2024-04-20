{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.git;
in {
  options = {
    git.with_lazygit = mkEnableOption "Adds lazy git configurations";
    git.delta = {
      enable = mkEnableOption "Adds delta git config";
      with-diff-so-fancy = mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enables diff so fancy configuration";
      };
    };
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
      delta = {
        enable = cfg.delta.enable;
        options = {
          side-by-side = true;
          line-numbers = true;
          dark = true;
          diff-so-fancy = cfg.delta.with-diff-so-fancy;
          tabs = 2;
          navigate = true;
        };
      };
    };
  };
}
