{ pkgs
, lib
, config
, paths
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
      with-personal-setup = mkEnableOption "Enable my configuration";
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
      add-zig = mkEnableOption "Add zig requirements";
    };
  };
  config = {
    custom.dev.nvim.enable = mkDefault true;
    custom.dev.nvim.with-personal-setup = mkDefault true;
    xdg.configFile.nvim = {
      enable = cfg.nvim.with-personal-setup;
      source = paths.app_configs + "/nvim";
    };
    xdg.configFile.neovide = {
      enable = cfg.neovide.enable;
      source = paths.app_configs + "/neovide";
    };
    home.packages =
      (lib.concatMap optionalPackage [
        cfg.nvim
        cfg.neovide
      ])
      ++ optionals cfg.lang.add-rust [ pkgs.rustc pkgs.rustfmt pkgs.cargo pkgs.rust-analyzer pkgs.vscode-extensions.vadimcn.vscode-lldb ]
      ++ optionals cfg.lang.add-go [ pkgs.go ]
      ++ optionals cfg.lang.add-nix [ pkgs.nixd pkgs.nixpkgs-fmt pkgs.statix ]
      ++ optionals cfg.lang.add-zig [ pkgs.zig pkgs.zls ]
      ++ optionals cfg.nvim.enable [ pkgs.nodejs pkgs.sqlite pkgs.luarocks pkgs.prettierd pkgs.lua5_1 ]
      ++ [ pkgs.gnumake ];
  };
}
