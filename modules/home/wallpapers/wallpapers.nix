{
  lib,
  config,
  pkgs,
  ...
}:
{
  options =
    let
      inherit (lib) mkOption;
      inherit (lib.types)
        path
        submodule
        str
        nullOr
        listOf
        ;
    in
    {
      custom.wallpapers = mkOption {
        type =
          listOf
          <| submodule {
            options = {
              monitor = mkOption {
                type = str;
                example = "DP-1";
              };
              path = mkOption {
                type = nullOr path;
                example = "../wallpaper.png";
                default = null;
              };
              wallhaven = mkOption {
                type =
                  nullOr
                  <| submodule {
                    options = {
                      id = mkOption {
                        type = str;
                        example = "123c15";
                      };
                      resize = mkOption {
                        type = str;
                        example = "3440x1440";
                        description = "Auto Crops to the size";
                      };
                    };
                  };
                example = {
                  id = "123c15";
                  resize = "3440x1440";
                };
                default = null;
              };
            };
          };
      };
    };

  config = {
    xdg.configFile."swww/activation" = {
      text =
        let
          fromWallhaven = wallhaven: import ./mkWallhavenDerivation.nix { inherit wallhaven pkgs; };
          fromDerivation = output: der: "swww img ${der} -o ${output}\n";
          fromWallpaper =
            wallpaper:
            if wallpaper.path == null then
              fromDerivation wallpaper.monitor <| fromWallhaven wallpaper.wallhaven
            else
              "swww img ${wallpaper.path} -o ${wallpaper.monitor}\n";
          intoScript = map fromWallpaper config.custom.wallpapers;
        in
        ''
          #!${pkgs.nushell}/bin/nu

          ${intoScript}
        '';
      executable = true;
    };
  };
}
