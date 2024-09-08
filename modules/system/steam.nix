{ lib, config, ... }:
{
  options.custom.games = {
    steam.enable = lib.mkEnableOption "Enable to install steam";
    minecraft.enable = lib.mkEnableOption "Enable to install java for minecraft";
  };
  config = {
    programs.steam = {
      inherit (config.custom.games.steam) enable;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.java.enable = config.custom.games.minecraft.enable;
  };
}
