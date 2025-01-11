{ pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "murex-module-starship";

  src = pkgs.fetchFromGitHub {
    owner = "orefalo";
    repo = "murex-module-starship";
    rev = "42b1b13bfbd65c5fe405a3a4ff1c5790b778c78c";
    hash = "sha256-E7oGk2CV/nZuCL2n14RqCxKbJ3zddb+3itR59HgXNaU=";
  };

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out
  '';
})
