{ pkgs }:
let
  pname = "zen-browser";
  version = "1.0.1-a.19";

  src = pkgs.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    hash = "sha256-qAPZ4VyVmeZLRfL0kPHF75zyrSUFHKQUSUcpYKs3jk8=";
  };
  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/pixmaps
    cp ${appimageContents}/zen.desktop $out/share/applications/
    cp ${appimageContents}/zen.png $out/share/pixmaps/

    for n in {16,32,48,64,128}; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      file="default"$n".png"
      cp ${appimageContents}/browser/chrome/icons/default/$file $out/share/icons/hicolor/$size/apps/zen.png
    done

    substituteInPlace $out/share/applications/zen.desktop \
      --replace-fail "Exec=zen %u" "Exec=$out/bin/${pname} %u"
  '';
}
