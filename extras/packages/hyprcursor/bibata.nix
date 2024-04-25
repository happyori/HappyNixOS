{ pkgs
, fetchzip ? pkgs.fetchzip
,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "bibata-hyprcursors";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Modern-Ice.tar.gz";
    hash = "sha256-Ji5gqIBrAtFO3S9fCrY/LXPaq5gCY4CkxZJ1uAcjj70=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out
    cp -rf . $out
  '';
}
