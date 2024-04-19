{ lib, config, pkgs, ... }:
{
  options = {
    terms = {
      kitty.enable = lib.mkEnableOption "enables kitty as main terminal";
    };
  };

  config = {
    programs.kitty = lib.mkIf config.terms.kitty.enable {
      enable = true;
      font.package = (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; });
      font.name = "CaskaydiaCove Nerd Font";
      font.size = 14;
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
      };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        disable_ligatures = "never";
        cursor_shape = "beam";
        shell = "${pkgs.nushell}/bin/nu";
        editor = "${pkgs.neovide}/bin/neovide";
        background_opacity = "0.5";
        shell_integration = "enabled";
      };
      theme = "Sakura Night";
    };
  };
}
