{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "happy";
  home.homeDirectory = "/home/happy";

  imports = [
    ./modules/home/default.nix
  ];

  terms.kitty.enable = true;
  shells.nushell.enable = true;
  git = {
    with_lazygit = true;
    delta = {
      enable = true;
      with-diff-so-fancy = true;
    };
  };
  discord = {
    enable = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # imports = [ inputs._1password-shell-plugins.hmModules.default ];
  # programs._1password-shell-plugins = {
  #   enable = true;
  #   plugins = with pkgs; [
  #     gh
  #   ];
  # };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FantasqueSansMono" "CascadiaCode" "JetBrainsMono"];})
    neovim-nightly
    vivaldi
    neovide
    gh
    nodejs
    go
    rustc
    cargo
    alejandra
    sqlite
    bat
    nixd
  ];

  services.blueman-applet.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
      	IdentityAgent ~/.1password/agent.sock
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/happy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
