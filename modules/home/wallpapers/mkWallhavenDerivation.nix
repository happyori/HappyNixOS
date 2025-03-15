{ pkgs, wallhaven }:
pkgs.stdenvNoCC.mkDerivation {
  name = "wallhaven-${wallhaven.id}";
  src = pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper-${wallhaven.id}";
    builder = ./builder.sh;
    nativeBuildInputs = [
      pkgs.nushell
      pkgs.imagemagick
    ];
    wallhavenId = wallhaven.id;
    resize = wallhaven.size;
    script = ./wallhaven.nu;
    dontUnpack = true;
  };
  installPhase = ''cp $src/${wallhaven.id}.png $out'';
}
