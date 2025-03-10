{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.lutris
    # pkgs.vintagestory Dotnet Runtime Out of Date
    pkgs.wineWowPackages.wayland
  ];
}
