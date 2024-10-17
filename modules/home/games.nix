{ pkgs
, ...
}:
let
  vintagestory = pkgs.vintagestory.overrideAttrs (final: previous: rec {
    version = "1.19.8";
    src = pkgs.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
      hash = "sha256-R6J+ACYDQpOzJZFBizsQGOexR7lMyeoZqz9TnWxfwyM=";
    };
  });
in
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.lutris
    vintagestory
  ];
}
