{ pkgs
, ...
}:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.lutris
    pkgs.vintagestory
    pkgs.wineWowPackages.wayland
  ];
}
