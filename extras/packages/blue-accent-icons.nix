{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "blue-accent-icons";
  src = pkgs.fetchFromGitHub {
    owner = "PENWINthePIRATE";
    repo = "Blue-Accent-Icons-for-linux";
    rev = "d4e278eb6b2b637c403bfd166272b816af507afe";
    hash = "sha256-HWt7AjHVB3Zdno+TYw/Puojn9oEzZ91UDzFOXAtL2+k=";
  };

  installPhase = ''
    mkdir -p $out/Blue-Accent-Icons
    cp -r ./* $out/Blue-Accent-Icons
  '';
}
