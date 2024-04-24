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
          PROMPT_INDICATOR_VI_INSERT = "";
          PROMPT_INDICATOR_VI_NORMAL = "";
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

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "[╭⤳](purple) $directory ≀ $hostname⋮ $username ≀ $nix_shell"
          "$fill"
          "$localip ≀ $time $all" # Right side of the prompt
          "$line_break"
          "[├](purple) $cmd_duration ≀ $package"
          "$line_break"
          "[╰╴](purple)$sudo $character "
        ];
        time = {
          disabled = false;
          format = "[$time]($style)";
          use_12hr = true;
          style = "italic bright-purple";
        };
        fill = {
          symbol = " ";
        };
        cmd_duration = {
          format = "[$duration]($style)";
          style = "italic purple";
          show_notifications = true;
          min_time_to_notify = 45000;
          min_time = 0;
        };
        directory = {
          home_symbol = "󰟒";
          truncation_symbol = "⋯ /";
          read_only = "";
          substitutions = {
            ".config" = " config";
            ".config/nixos" = " nixos";
            ".config/hypr" = " hyprland";
          };
        };
        character = {
          success_symbol = "[⊚](bold italic bright-green)";
          error_symbol = "[󰨐](bold italic bright-red)";
        };
        hostname = {
          ssh_symbol = "󰣀";
          ssh_only = false;
        };
        nix_shell = {
          symbol = "󰼪";
          impure_msg = "󰼩 ";
          pure_msg = "󱩰 ";
          format = "$symbol shell [$state\[$name\]]($style)";
        };
        localip = {
          disabled = false;
          ssh_only = false;
        };
        sudo = {
          disabled = false;
          symbol = "⬢";
          style = "bold green";
          format = "[$symbol]($style)";
        };
        username = {
          format = "[$user]($style)";
          show_always = true;
        };
      };
      enableNushellIntegration = true;
    };

    home.packages = [
      pkgs.nu_scripts
      inc_plugin
    ];
    home.file."${config.xdg.cacheHome}/nushell/nu_scripts".source = "${pkgs.nu_scripts}/share/nu_scripts";
  };
}
