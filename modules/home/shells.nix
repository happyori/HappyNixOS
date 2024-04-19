{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.shells = {
    nushell.enable = mkEnableOption "Use nushell config";
  };

  imports = [
    ./shells/nushell.nix
  ];
}
