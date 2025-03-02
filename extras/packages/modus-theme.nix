{ pkgs }:
let
  pname = "modus-theme";
  version = "1.3.12";
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  src = pkgs.fetchFromGitHub {
    owner = "miikanissi";
    repo = "modus-themes.nvim";
    rev = "1f9ba82c732a49cdafc80f904286dd70f02c4310";
    hash = "sha256-H5E5dRFjUnt+paEJ5IJupSqBzcI4i0zufS8mggtvn9Y=";
  };

  installPhase = ''
    mkdir -p $out/themes/
    cp -R ./extras/ $out/themes/
  '';
}
