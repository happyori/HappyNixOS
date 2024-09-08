{ pkgs
, ...
}:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.lutris
  ];
}
