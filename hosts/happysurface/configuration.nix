{ config
, lib
, pkgs
, system
, inputs
, paths
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    (paths.sys_modules + /default.nix)
  ];

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      zfsSupport = true;
      device = "nodev";
    };
  };

  boot.supportedFilesystems = [ "zfs" ];

  nix = {
    settings = {
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
      experimental-features = [ "nix-command" "flakes" ];
    };
    buildMachines = [{
      system = "x86_64-linux";
      speedFactor = 2;
      supportedFeatures = [
        "kvm"
        "big-parallel"
        "benchmark"
        "nixos-test"
      ];
      protocol = "ssh-ng";
      maxJobs = 4;
      hostName = "builder";
    }];
    distributedBuilds = true;
    extraOptions = "builders-use-substitutes = true";
  };


  networking = {
    hostName = "happysurface";
    networkmanager.enable = true;
    hostId = "4e98920d"; # Change this on the machine
  };

  time.timeZone = "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  greeter.greetd.enable = false;
  greeter.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.dconf.enable = true;
  programs.hyprland.enable = true;

  security.polkit.enable = true;

  environment.pathsToLink = [ "/share/icons" ];

  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages =
    [
      pkgs.gnome-photos
      pkgs.gnome-tour
      pkgs.gnome-online-accounts
      pkgs.evolution-data-server
      pkgs.gedit
    ]
    ++ (with pkgs.gnome; [
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
    ]);
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  custom._1password.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.happy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  nixpkgs.overlays = [
    inputs.nixd.overlays.default
    (final: prev: {
      inherit (inputs.nixpkgs.legacyPackages.${system}) networkmanager-openconnect;
    })
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.happy = import ./home.nix;
  home-manager.extraSpecialArgs = {
    inherit inputs paths system;
    custom-options = config.custom;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    cachix
    ripgrep
  ];

  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/happy/.config/nixos/";
  };

  programs.npm.enable = true;

  programs.nix-index.enableZshIntegration = false;
  programs.nix-index.enableBashIntegration = false;
  programs.nix-index.enableFishIntegration = false;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
