{ pkgs
, paths
, ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "happy";
  home.homeDirectory = "/home/happy";

  imports = [
    (paths.home_modules + /default.nix)
  ];

  custom = {
    wallpaper = paths.wallpapers + /AlienPlanet.jpg;
    shells.nushell.enable = true;
    utils.zoxide.enable = true;
    utils.ssh.enable = true;
    git = {
      with_lazygit = true;
      delta = {
        enable = false;
        with-diff-so-fancy = true;
      };
      kitty-diff.enable = true;
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
        add-rust = true;
        add-nix = true;
        add-go = true;
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
      }
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        refresh = 169.83;
        x = -2560;
        y = 0;
        scale = "auto";
      }
      {
        name = "Unknown-1";
        enable = false;
      }
    ];
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
