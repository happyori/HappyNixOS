{ config, lib, ... }:
let
  cfg = config.custom.shells;
  inherit (lib) mkIf;
in
{
  options.custom.shells.enableStarshipIntegration = lib.mkEnableOption "Enables the starship setup";
  config = mkIf cfg.enableStarshipIntegration {
    programs.starship = {
      enable = true;
      enableFishIntegration = cfg.fish.enable;
      enableNushellIntegration = cfg.nushell.enable;
      settings = {
        add_newline = true;
        continuation_prompt = "[▸▹ ](dimmed white)";
        format = ''($nix_shell$container$fill$git_metrics''\n)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character'';
        right_format = ''$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$zig$buf$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$os$battery$time'';

        git_branch = {
          format = " [$branch(:$remote_branch)]($style)";
          symbol = "[△](bold italic bright-blue)";
          style = "italic bright-blue";
          truncation_symbol = "⋯ ";
          truncation_length = 11;
          ignore_branches = [ "main" "master" ];
          only_attached = true;
        };
        git_metrics = {
          format = "([▴$added]($added_style))([▿$deleted]($deleted_style))";
          added_style = "italic dimmed green";
          deleted_style = "italic dimmed red";
          ignore_submodules = true;
          disabled = false;
        };
        git_status = {
          style = "bold italic bright-blue";
          format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
          conflicted = "[◪◦](italic bright-magenta)";
          ahead = "[▴│[\${count}](bold white)│](italic green)";
          behind = "[▿│[\${count}](bold white)│](italic red)";
          diverged = "[◇ ▴┤[\${ahead_count}](regular white)│▿┤[\${behind_count}](regular white)│](italic bright-magenta)";
          untracked = "[◌◦](italic bright-yellow)";
          stashed = "[◃◈](italic white)";
          modified = "[●◦](italic yellow)";
          staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
          renamed = "[◎◦](italic bright-blue)";
          deleted = "[✕](italic red)";
        };

        time = {
          disabled = false;
          format = "[ $time]($style)";
          use_12hr = true;
          style = "italic dimmed white";
        };
        fill = {
          symbol = " ";
        };
        cmd_duration = {
          format = "[◄ $duration ]($style)";
          style = "italic white";
          show_notifications = false;
          min_time_to_notify = 45000;
          min_time = 0;
        };
        directory = {
          home_symbol = "󰟒";
          truncation_length = 3;
          truncation_symbol = "⋯ /";
          read_only = "";
          substitutions = {
            "nixos" = " nixos";
            "hypr" = " hyprland";
            ".config" = " config";
          };
          repo_root_style = "bold blue";
          repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
        };
        env_var.VIMSHELL = {
          format = "[$env_value]($style)";
          style = "green italic";
        };
        jobs = {
          format = "[$symbol$number]($style) ";
          style = "white";
          symbol = "[▶](blue italic)";
        };
        character = {
          format = " $symbol ";
          success_symbol = "[◎](bold italic bright-yellow)";
          error_symbol = "[○](italic purple)";
          vimcmd_symbol = "[■](italic dimmed green)";
          # not supported in zsh
          vimcmd_replace_one_symbol = "◌";
          vimcmd_replace_symbol = "□";
          vimcmd_visual_symbol = "▼";
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
          ssh_only = true;
          format = " ◯[$localipv4](bold magenta)";
        };
        sudo = {
          disabled = false;
          symbol = "⋈┈";
          style = "bold italic bright-purple";
          format = "[$symbol]($style)";
        };
        username = {
          format = "[ ⭘ $user]($style)";
          show_always = true;
          style_user = "bright-yellow bold italic";
          style_root = "purple bold italic";
        };
      };
    };
  };
}
