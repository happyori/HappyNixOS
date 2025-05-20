{
  pkgs,
  paths,
  lib,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "happy";
  home.homeDirectory = "/home/happy";

  imports = [
    (paths.home_modules + /default.nix)
  ];

  custom = {
    wallpapers = [
      {
        monitor = "DP-2";
        path = paths.wallpapers + /AlienPlanet.jpg;
      }
      {
        monitor = "DP-1";
        wallhaven = {
          id = "3lpe76";
          resize = "3440x1440";
          hash = "sha256-EJX8V+Nj/SusZcspHLtybbSzJEd3X1jdtpEbPmO1NXY=";
        };
      }
    ];
    shells.nushell.enable = true;
    shells.murex =
      let
        murex_path = paths.custom_pkgs + /murex;
        module_pkgs = lib.attrNames (lib.filterAttrs (n: v: v == "regular") (builtins.readDir murex_path));
        module_paths = map (p: "${murex_path}/${p}") module_pkgs;
        modules = map (pkg: import pkg { inherit pkgs; }) module_paths;
      in
      {
        enable = false;
        inherit modules;
      };
    shells.fish.enable = true;
    utils.zoxide.enable = true;
    utils.ssh.enable = true;
    hardware.nvidia.enable = false;
    git = {
      with_lazygit = true;
      delta = {
        enable = false;
        with-diff-so-fancy = true;
      };
      kitty-diff.enable = false;
      difftastic.enable = true;
    };
    terms.kitty.enable = true;
    discord = {
      enable = true;
      withVencord = true;
      withVesktop = true;
    };
    dev = {
      neovide.enable = true;
      nvim = {
        enable = true;
        with-lazy-vim = true;
        package = pkgs.neovim;
      };
      lang = {
        add-haskell = false;
        add-gleam = true;
        add-rust = true;
        add-nix = true;
        add-go = true;
        add-csharp = false;
      };
    };
    hyprland.monitors = [
      {
        name = "HDMI-A-1";
        width = 2560;
        height = 1440;
        refresh = 143.97;
        x = 0;
        y = 0;
        scale = "auto";
        enable = false;
      }
      {
        name = "DP-2";
        width = 2560;
        height = 1440;
        refresh = 169.83;
        x = -2560;
        y = 0;
        scale = "auto";
      }
      {
        name = "DP-1";
        width = 3440;
        height = 1440;
        refresh = 164.90;
        x = 0;
        y = 0;
        scale = "auto";
      }
      {
        name = "Unknown-1";
        enable = false;
      }
    ];
  };
  services.udiskie = {
    enable = true;
    automount = true;
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
