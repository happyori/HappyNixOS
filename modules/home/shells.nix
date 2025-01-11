{ lib
, ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  options.custom = {
    shells.nushell.enable = mkEnableOption "Use nushell config";
  };

  imports = [
    ./shells/nushell.nix
    ./shells/murex.nix
  ];
}
