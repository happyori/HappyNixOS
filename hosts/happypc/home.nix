{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "happy";
  home.homeDirectory = "/home/happy";

  imports = [
    ../../modules/home/default.nix
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
  };

  home.packages = with pkgs; [
    neovim-nightly
    neovide
    nodejs
    go
    rustc
    cargo
    alejandra
    sqlite
    nixd
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
