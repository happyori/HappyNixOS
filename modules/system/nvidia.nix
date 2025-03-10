{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom.hardware.nvidia.enable =
    lib.mkEnableOption "Enable for proprietary, disable for nouveau";
  config = lib.mkIf config.custom.hardware.nvidia.enable {
    boot = {
      kernelModules = [ "nvidia_uvm" ];
      kernelParams = [
        "nomodeset"
        "nvidia_drm.fbdev=1"
      ];
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = true;
          finegrained = false;
        };
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = [
      pkgs.nvidia-vaapi-driver
      pkgs.egl-wayland
    ];
  };
}
