{
  inputs,
  system,
  config,
  ...
}:
let
  quickshell = inputs.quickshell.packages."${system}".default;
  profile = config.home.profileDirectory;
in
{
  home.packages = [ quickshell ];
  home.sessionVariables = {
    "QML2_IMPORT_PATH" = "${profile}/lib/qt-6/qml";
  };
}
