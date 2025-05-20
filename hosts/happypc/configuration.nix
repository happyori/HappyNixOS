# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  system,
  inputs,
  paths,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared/configuration.nix
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

  networking = {
    hostName = "happypc"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    hostId = "9afd7ec6";
    firewall = {
      checkReversePath = "loose";
    };
  };

  # Set your time zone.
  time.hardwareClockInLocalTime = false;

  custom = {
    hardware.nvidia.enable = false;
    hardware.amdgpu.enable = true;
    games.steam.enable = true;
    games.minecraft.enable = true;
  };

  services.openssh = {
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

  users.users.happy = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
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
