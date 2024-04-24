{
  pkgs,
  appimageTools ? pkgs.appimageTools,
  fetchurl ? pkgs.fetchurl,
}:
appimageTools.wrapType2 {
  name = "lychee-beta";
  src = fetchurl {
    url = "https://bit.ly/6-0-1-AppImage";
    hash = "sha256-BRU95BAbnABL78S3DBHvmSuGqlyjEldB+F+qGnrY2tQ=";
  };
}
