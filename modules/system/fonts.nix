{ pkgs, ... }:
{
  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "CascadiaCode" "JetBrainsMono" "FiraCode" ]; })
    pkgs.inter
    pkgs.dina-font
  ];
}
