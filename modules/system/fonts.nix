{ pkgs, ... }:
{
  fonts = {
    packages = [
      pkgs.nerd-fonts.fantasque-sans-mono
      pkgs.nerd-fonts.caskaydia-cove
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.inter
      pkgs.dina-font
    ];
    fontconfig.enable = true;
    fontDir.enable = true;
    enableDefaultPackages = true;
  };
}
