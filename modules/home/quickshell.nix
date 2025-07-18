{
  inputs,
  system,
  config,
  paths,
  ...
}:
let
  quickshell = inputs.quickshell.packages."${system}".default;
  caelestia = inputs.caelestia.packages."${system}".default;
  profile = config.home.profileDirectory;
in
{
  home.packages = [
    quickshell
    caelestia
  ];
  home.sessionVariables = {
    "QML2_IMPORT_PATH" = "${profile}/lib/qt-6/qml";
  };

  home.file =
    let
      wallpapers = config.custom.wallpapers;
      isWallhaven = wp: wp.wallhaven == null;
      getWpName = wp: wp.wallpaper_name;
      fromWallhaven = config.custom.fromWallhaven;
    in
    wallpapers
    |> map (wp: {
      "${getWpName wp}".source = if isWallhaven wp then fromWallhaven wp else wp.path;
    });

  # xdg.configFile."caelestia/shell.json" = {
  #   source = paths.app_configs + "caelestia/shell.json";
  # };
}
