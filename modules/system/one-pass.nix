{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [
    inputs._1password-shell-plugins.nixosModules.default
  ];

  options = {
    custom._1password.enable = mkEnableOption "Enable one password setup";
  };

  config = mkIf config.custom._1password.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = ["happy"];
    };
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          vivaldi-bin
        '';
        mode = "0755";
      };
    };

    programs._1password-shell-plugins = {
      enable = true;
      plugins = [pkgs.gh];
    };
  };
}
