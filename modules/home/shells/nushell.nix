{ config
, lib
, pkgs
, custom-options
, paths
, ...
}:
let
  cfg = config.custom.shells.nushell;
  nuxFile = paths.app_configs + /nushell/nux.nu;
  nxvimFile = paths.app_configs + /nushell/nixvim.nu;
  inherit (lib) mkIf;
  sourceCompletion = package: "source ${config.xdg.cacheHome}/nushell/nu_scripts/custom-completions/${package}/${package}-completions.nu";
in
{
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
            inherit (custom-options._1password) plugins;
            pkg-exe-names = map (package: strings.unsafeDiscardStringContext (baseNameOf (getExe package))) plugins;
            aliases = listToAttrs (map
              (
                package: {
                  name = package;
                  value = "op plugin run -- ${package}";
                }
              )
              pkg-exe-names);
          in
          aliases
        );
      environmentVariables = {
        EDITOR = "'nvim'";
        SSH_AUTH_SOCK = "($env.HOME | path join '1password' 'agent.sock')";
      };
      extraConfig = ''
        alias la = ls -a
        source ${nuxFile}
        source ${nxvimFile}
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
        add_newline = true;
        format = lib.concatStrings [
          "[╭⤳](purple) $directory ≀ $hostname⋮ $username ≀ $nix_shell"
          "$fill"
          "$localip ≀ $time" # Right side of the prompt
          "$line_break"
          "[├](purple) $cmd_duration ≀ $all"
          "$line_break"
          "[╰╴](purple)$sudo $character"
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
          truncation_length = 5;
          truncation_symbol = "⋯ /";
          read_only = "";
          substitutions = {
            "nixos" = " nixos";
            "hypr" = " hyprland";
            ".config" = " config";
          };
        };
        character = {
          success_symbol = "[⊚](bold italic bright-green)";
          error_symbol = "[󰨐](bold italic bright-red)";
        };
        hostname = {
          ssh_symbol = "󰣀";
          ssh_only = false;
          format = "[$ssh_symbol$hostname]($style)";
        };
        nix_shell = {
          symbol = "󰼪";
          impure_msg = "󰼩 ";
          pure_msg = "󱩰 ";
          format = "$symbol shell [$state\\[$name\\]]($style)";
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
          style_user = "bold bright-purple";
        };
      };
      enableNushellIntegration = true;
    };

    home.packages = [
      pkgs.nu_scripts
    ];
    home.file."${config.xdg.cacheHome}/nushell/nu_scripts".source = "${pkgs.nu_scripts}/share/nu_scripts";
    home.file."Scripts/launch_gnome_polkit.nu".source = "${paths.scripts}/launch_gnome_polkit.nu";
    home.file."Scripts/toggle_clipse.nu".source = "${paths.scripts}/toggle_clipse.nu";
  };
}
