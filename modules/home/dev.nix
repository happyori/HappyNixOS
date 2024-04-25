{ pkgs
, lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkDefault mkOption types optional optionals;
  optionalPackage = opt: optional (opt != null && opt.enable && opt.package != null) opt.package;
  cfg = config.custom.dev;
in
{
  options.custom.dev = {
    neovide.enable = mkEnableOption "Enable neovide settings";
    neovide.package = mkOption {
      type = types.package;
      default = pkgs.neovide;
    };
    nvim = {
      enable = mkEnableOption "Enable neovim";
      with-lazy-vim = mkEnableOption "Enable lazy vim configuration";
      package = mkOption {
        type = types.package;
        default = pkgs.neovim;
        description = ''
          Package to use to install neovim
        '';
      };
    };
    lang = {
      add-rust = mkEnableOption "Add rust requirements";
      add-go = mkEnableOption "Add go requirements";
      add-nix = mkEnableOption "Add nix requirements";
    };
  };
  config = {
    custom.dev.nvim.enable = mkDefault true;
    home.packages =
      (lib.concatMap optionalPackage [
        cfg.nvim
        cfg.neovide
      ])
      ++ optionals cfg.lang.add-rust [ pkgs.rustc pkgs.cargo ]
      ++ optionals cfg.lang.add-go [ pkgs.go ]
      ++ optionals cfg.lang.add-nix [ pkgs.nixd pkgs.nixpkgs-fmt pkgs.statix ]
      ++ optionals cfg.nvim.enable [ pkgs.nodejs pkgs.sqlite ];
  };
}
