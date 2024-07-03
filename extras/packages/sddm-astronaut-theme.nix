{ pkgs
, formats ? pkgs.formats
,
}:
let
  image = ../wallpapers/sddm/background.png;
  output = "$out/share/sddm/themes/Astronaut";
  userCfg = (formats.ini { }).generate "theme.conf.user" {
    General = {
      ScreenWidth = "2560";
      ScreenHeight = "1440";
      BlurRadius = "60";
      FormPosition = "left";
      PartialBlur = "true";
      HaveFormBackground = "true";
    };
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-astronaut-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "ac461e344a55e0949cf53a6c2c0b5c7dc55ea893";
    hash = "sha256-rcdwp4LZfTtckDYpBIuOYPxRuUjCgkOIuMgJ2mVhngc=";
  };

  nativeBuildInputs = [ pkgs.imagemagick ];

  installPhase = ''
    # Installation
    mkdir -p ${output}
    cp -R ./* ${output}
    cd ${output}
    # Setup background
    rm background.png
    magick ${image} "./background.png"
    # Setup userCfg
    ln -sf ${userCfg} ${output}/theme.conf.user
  '';
}
