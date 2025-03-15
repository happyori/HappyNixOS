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
    inherit (wallhaven) resize;
    script = ./wallhaven.nu;
    dontUnpack = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = wallhaven.hash;
  };
  installPhase = ''cp $src/${wallhaven.id}.png $out'';
}
