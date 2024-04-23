{
  config,
  lib,
  pkgs,
  custom-options,
  paths,
  ...
}: let
  cfg = config.custom.shells.nushell;
  nuxFile = paths.app_configs + /nushell/nux.nu;
  inherit (lib) mkIf;
  sourceCompletion = package: "source ${config.xdg.cacheHome}/nushell/nu_scripts/custom-completions/${package}/${package}-completions.nu";
  inc_plugin = pkgs.callPackage (paths.custom_pkgs + /nushell/plugins/inc.nix) {};
in {
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = paths.app_configs + /nushell/config.nu;
      shellAliases =
        {
          nr = "nux rebuild";
          l = "la -s";
          ll = "la -l";
        }
        // lib.optionalAttrs custom-options._1password.enable (
          let
            inherit (lib) listToAttrs strings getExe;
            inherit (builtins) map;
            plugins = custom-options._1password.plugins;
            pkg-exe-names = map (package: strings.unsafeDiscardStringContext (baseNameOf (getExe package))) plugins;
            aliases = listToAttrs (map (
                package: {
                  name = package;
                  value = "op plugin run -- ${package}";
                }
              )
              pkg-exe-names);
          in
            aliases
        );
      environmentVariables =
        {
          EDITOR = "nvim";
          SSH_AUTH_SOCK = "($env.HOME | path join '1password' 'agent.sock')";
        }
        // config.home.sessionVariables;
      extraConfig = ''
        alias la = ls -a
        source ${nuxFile}
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

    home.packages = [
      pkgs.nu_scripts
      inc_plugin
    ];
    home.file."${config.xdg.cacheHome}/nushell/nu_scripts".source = "${pkgs.nu_scripts}/share/nu_scripts";
  };
}
