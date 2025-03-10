{
  lib,
  config,
  ...
}:
let
  cfg = config.greeter;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.greeter = {
    greetd.enable = mkEnableOption "Enable greetd option, disables other modules";
  };

  config = mkIf cfg.greetd.enable {
    services.greetd = {
      enable = true;
      vt = 1;
    };
    programs.regreet = {
      enable = true;
    };
    services.xserver.displayManager.sddm.enable = false;
    services.xserver.displayManager.gdm.enable = false;
    services.xserver.displayManager.lightdm.enable = false;
  };
}
