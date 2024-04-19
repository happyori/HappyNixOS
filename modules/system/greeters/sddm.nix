{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.greeter;
  inherit (lib) mkIf mkEnableOption;
  theme = import ../../../extras/packages/sddm-astronaut-theme.nix {
    inherit pkgs;
  };
in {
  options.greeter.sddm = {
    enable = mkEnableOption "Enable sddm greeter";
    wayland.enable = mkEnableOption "Enable wayland sddm";
  };

  config = mkIf cfg.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = cfg.sddm.wayland.enable;
      theme = "Astronaut";
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        pkgs.qt6.qt5compat
      ];
    };

    environment.systemPackages = with pkgs; [
      qt6.qt5compat
      qt6.qtdeclarative
      qt6.qtsvg
      qt5.qtgraphicaleffects
      theme
    ];
  };
}
