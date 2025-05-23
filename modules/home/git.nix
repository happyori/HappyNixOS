{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.custom.git;
in
{
  options.custom.git = {
    with_lazygit = mkEnableOption "Adds lazy git configurations";
    delta = {
      enable = mkEnableOption "Adds delta git config";
      with-diff-so-fancy = mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enables diff so fancy configuration";
      };
    };
    kitty-diff = {
      enable = mkEnableOption "Use kitten diff from kitty";
    };
    difftastic.enable = mkEnableOption "Use difftastic as defaut diff tool";
  };

  config = {
    programs.lazygit = {
      enable = cfg.with_lazygit;
      settings = {
        gui = {
          nerdFontVersion = "3";
        };
        os = {
          edit = "nvim {{filename}}";
          editAtLine = "nvim -c '{{line}}G' {{filename}}";
        };
      };
    };

    programs.git = {
      enable = true;
      ignores = [
        "*.root"
        "*.swap"
      ];
      userEmail = "orkhan.tahirov@gmail.com";
      userName = "happyori";
      extraConfig =
        {
          init = {
            defaultBranch = "main";
          };
        }
        // lib.optionalAttrs cfg.kitty-diff.enable {
          diff = {
            tool = "kitty";
            guitool = "kitty.gui";
          };
          difftool = {
            prompt = false;
            trustExitCode = true;
          };
          "difftool \"kitty\"" = {
            cmd = "kitten diff $LOCAL $REMOTE";
          };
          "difftool \"kitty.gui\"" = {
            cmd = "kitten diff $LOCAL $REMOTE";
          };
        };
      difftastic = {
        inherit (cfg.difftastic) enable;
      };
      delta = {
        inherit (cfg.delta) enable;
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
