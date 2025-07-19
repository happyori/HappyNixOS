{
  inputs,
  system,
  config,
  pkgs,
  ...
}:
let
  quickshell = inputs.quickshell.packages."${system}".default;
  caelestia = inputs.caelestia.packages."${system}".default;
  caelestia-cli = inputs.caelestia-cli.packages."${system}".default;
  profile = config.home.profileDirectory;
in
{
  home.packages = [
    quickshell
    caelestia
    caelestia-cli
    pkgs.material-symbols
  ];
  home.sessionVariables = {
    "QML2_IMPORT_PATH" = "${profile}/lib/qt-6/qml";
  };

  home.file =
    let
      wallpapers = config.custom.wallpapers;
      isWallhaven = wp: wp.wallhaven != null;
      getWpName = wp: wp.wallpaper_name;
      fromWallhaven = config.custom.fromWallhaven;
    in
    wallpapers
    |> map (wp: {
      name = config.xdg.userDirs.pictures + "/Wallpapers/" + getWpName wp;
      value = {
        source = if isWallhaven wp then fromWallhaven wp.wallhaven else wp.path;
      };
    })
    |> builtins.listToAttrs;

  # xdg.configFile."caelestia/shell.json" = {
  #   source = paths.app_configs + "caelestia/shell.json";
  # };
}
