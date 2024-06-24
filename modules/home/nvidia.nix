{ lib, ... }:
{
  options.custom.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable nvidia options";
  };
}
