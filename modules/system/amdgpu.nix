{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom.hardware.amdgpu.enable = lib.mkEnableOption "Enable AMD GPU system options";
  config = lib.mkIf config.custom.hardware.amdgpu.enable {
    boot = {
      initrd.kernelModules = [ "amdgpu" ];
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    hardware = {
      graphics = {
        enable32Bit = true;
        extraPackages = [
          pkgs.rocmPackages.clr.icd
          pkgs.amdvlk
        ];
      };
    };

    environment.systemPackages = [ pkgs.clinfo ];
  };
}
