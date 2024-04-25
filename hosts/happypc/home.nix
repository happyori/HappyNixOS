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
        package = pkgs.neovim-nightly;
      };
      lang = {
        add-rust = true;
        add-nix = true;
        add-go = true;
      };
    };
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
