{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom.games = {
    steam.enable = lib.mkEnableOption "Enable to install steam";
    minecraft.enable = lib.mkEnableOption "Enable to install java for minecraft";
  };
  config = {
    programs = {
      steam = {
        inherit (config.custom.games.steam) enable;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = config.custom.games.steam.enable;
        localNetworkGameTransfers.openFirewall = true;
      };
      gamescope = {
        inherit (config.custom.games.steam) enable;
        capSysNice = true;
      };
      java.enable = config.custom.games.minecraft.enable;
      gamemode.enable = config.custom.games.steam.enable;
    };
    environment.systemPackages = lib.optionals config.custom.games.steam.enable [
      pkgs.mangohud
      pkgs.protonup
    ];
  };
}
