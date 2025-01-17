{ config
, lib
, pkgs
, system
, inputs
, paths
, ...
}: {
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [ "happy" ];
    experimental-features = [ "pipe-operators" "nix-command" "flakes" ];
  };

  time.timeZone = "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  i18n.defaultLocale = "en_US.UTF-8";
  security.polkit.enable = true;

  greeter.greetd.enable = false;
  greeter.sddm = {
    enable = true;
    wayland.enable = true;
  };
  programs = {
    dconf.enable = true;
    hyprland = {
      enable = true;
    };
    fish.enable = true;
    fish.useBabelfish = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/happy/.config/nixos/";
    };
    npm.enable = true;
    nix-index = {
      enableZshIntegration = false;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
  };
  custom._1password.enable = true;
  hardware.pulseaudio.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nixd.overlays.default
    (final: prev: {
      inherit (inputs.nixpkgs.legacyPackages.${system}) networkmanager-openconnect;
    })
  ];
  services = {
    udev.packages = [ pkgs.gnome-settings-daemon ];
    xserver.enable = true;
    xserver.desktopManager.gnome.enable = lib.mkDefault false;
    blueman.enable = true;
    openssh.enable = lib.mkDefault true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      curl
      bash
      git
      elegant-sddm
      gcc
      killall
      polkit_gnome
      gtk3
      gtk4
      unzip
      fswatch
      fd
      fzf
      gnomeExtensions.appindicator
      babelfish
      cachix
      ripgrep
      networkmanagerapplet
      inputs.nux.packages.${system}.default
    ];
    pathsToLink = [ "/share/icons" ];
    gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-online-accounts
      gedit
      evolution-data-server
      cheese
      gnome-music
      gnome-terminal
      epiphany
      geary
      evince
      gnome-characters
      gnome-calendar
      totem
      tali
      iagno
      hitori
      atomix
    ];
  };
}
