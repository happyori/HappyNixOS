{ lib, config, ... }:
{
  options =
    let
      inherit (lib) mkOption;
      inherit (lib.types)
        either
        path
        submodule
        str
        nullOr
        functionTo
        package
        ;
    in
    {
      custom.wallpaper = mkOption {
        type =
          either path
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
                      hash = mkOption {
                        type = str;
                      };
                    };
                  };
                example = {
                  id = "123c15";
                  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                };
                default = null;
              };
            };
          };
      };
      lib.mkWallhavenDerivation = mkOption {
        type = functionTo package;
      };
    };

  config = {
    xdg.configFile."swww/wallpaper".source = config.custom.wallpaper;
  };
}
