# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config
, lib
, pkgs
, system
, inputs
, paths
, ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (paths.sys_modules + /default.nix)
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        enable = true;
        efiSupport = true;
        zfsSupport = true;
        device = "nodev";
        extraEntries = ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root F691-4D65
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
        extraEntriesBeforeNixOS = true;
      };
    };
    supportedFilesystems = [ "zfs" ];
  };

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
    experimental-features = [ "nix-command" "flakes" ];
  };

  networking = {
    hostName = "happypc"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    hostId = "9afd7ec6";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = true;
  hardware.bluetooth.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

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
  hardware.pulseaudio.enable = false;

  custom = {
    hardware.nvidia.enable = true;
    games.steam.enable = true;
    games.minecraft.enable = true;
    _1password.enable = true;
  };
  security.polkit.enable = true;

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
      cachix
      ripgrep
    ];
    pathsToLink = [ "/share/icons" ];
    gnome.excludePackages =
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
  };

  services = {
    udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    xserver.enable = true;
    xserver.desktopManager.gnome.enable = false;
    printing.enable = true;
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
    openssh = {
      enable = true;
      ports = [ 401 ];
      authorizedKeysInHomedir = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        PermitRootLogin = "no";
        AllowUsers = [ "happy" ];
      };
    };
  };

  users.users.happy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };

  nixpkgs.overlays = [
    inputs.nixd.overlays.default
    (final: prev: {
      inherit (inputs.nixpkgs.legacyPackages.${system}) networkmanager-openconnect;
    })
  ];
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.happy = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs paths system;
      custom-options = config.custom;
    };
  };

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
