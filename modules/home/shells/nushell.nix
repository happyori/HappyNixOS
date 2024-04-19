{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.shells.nushell;
  nuxFile = ./nushell/nux.nu;
  inherit (lib) mkIf;
  sourceCompletion = package: "source ${config.xdg.cacheHome}/nushell/nu_scripts/custom-completions/${package}/${package}-completions.nu";
in {
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      shellAliases = {
        nr = "nux rebuild";
        l = "la -s";
        ll = "la -l";
      };
      environmentVariables = {
        EDITOR = "nvim";
        SSH_AUTH_SOCK = "($env.HOME | path join '1password' 'agent.sock')";
      };
      extraConfig = ''
        alias la = ls -a
        source ${nuxFile}
        ${sourceCompletion "gh"}
        ${sourceCompletion "nix"}
        ${sourceCompletion "rg"}
        ${sourceCompletion "cargo"}
        ${sourceCompletion "bat"}
      '';
    };

    # Used in the completions
    programs.fish.enable = true;
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    home.packages = with pkgs; [
      nu_scripts
    ];
    home.file."${config.xdg.cacheHome}/nushell/nu_scripts".source = "${pkgs.nu_scripts}/share/nu_scripts";
  };
}
