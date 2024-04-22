{
  config,
  lib,
  pkgs,
  # custom_options,
  ...
}: let
  cfg = config.shells.nushell;
  nuxFile = ./nushell/nux.nu;
  inherit (lib) mkIf;
  sourceCompletion = package: "source ${config.xdg.cacheHome}/nushell/nu_scripts/custom-completions/${package}/${package}-completions.nu";
  inc_plugin = pkgs.callPackage ../../../extras/packages/nushell/plugins/inc.nix {};
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
      # // lib.optionalAttrs custom_options._1password.enable (
      #   let
      #     inherit (lib) map getExeName listToAttrs;
      #     plugins = custom_options._1password.plugins;
      #     pkg-exe-names = map getExeName plugins;
      #     aliases = listToAttrs (map (package: {
      #         name = package;
      #         value = "op plugin run -- ${package}";
      #       })
      #       pkg-exe-names);
      #   in
      #     aliases
      # );
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

    home.packages = [
      pkgs.nu_scripts
      inc_plugin
    ];
    home.file."${config.xdg.cacheHome}/nushell/nu_scripts".source = "${pkgs.nu_scripts}/share/nu_scripts";
  };
}
