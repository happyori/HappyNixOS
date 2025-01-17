{ config
, pkgs
, system
, inputs
, paths
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/configuration.nix
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

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  users.users.happy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.happy = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs paths system;
      custom-options = config.custom;
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
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
