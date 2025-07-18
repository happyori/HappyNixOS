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
      custom.fromWallhaven = mkOption { };
      custom.wallpapers = mkOption {
        type =
          listOf
          <| submodule {
            options = {
              monitor = mkOption {
                type = str;
                example = "DP-1";
              };
              wallpaper_name = mkOption {
                type = str;
                default = "";
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
                      hash = mkOption {
                        type = str;
                        example = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                      };
                    };
                  };
                example = {
                  id = "123c15";
                  resize = "3440x1440";
                  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                };
                default = null;
              };
            };
          };
      };
    };

  config = {
    custom.fromWallhaven = wallhaven: import ./mkWallhavenDerivation.nix { inherit wallhaven pkgs; };
    xdg.configFile."swww/activation" = {
      text =
        let
          fromWallhaven = config.custom.fromWallhaven;
          fromDerivation = output: der: "swww img ${der} -o ${output}";
          fromWallpaper =
            wallpaper:
            if wallpaper.path == null then
              fromDerivation wallpaper.monitor <| fromWallhaven wallpaper.wallhaven
            else
              "swww img ${wallpaper.path} -o ${wallpaper.monitor}";
          fromWallpapers = map fromWallpaper config.custom.wallpapers;
          intoScript = lib.concatStringsSep "\n" fromWallpapers;
        in
        ''
          #!${pkgs.nushell}/bin/nu

          ${intoScript}
        '';
      executable = true;
    };
  };
}
