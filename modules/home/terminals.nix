{ lib
, config
, pkgs
, ...
}: {
  options.custom = {
    terms = {
      kitty.enable = lib.mkEnableOption "enables kitty as main terminal";
    };
  };

  config = {
    programs.kitty = lib.mkIf config.custom.terms.kitty.enable {
      enable = true;
      font.package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
      font.name = "CaskaydiaCove Nerd Font";
      font.size = 14;
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+u" = "scroll_page_up";
        "ctrl+d" = "scroll_page_down";
      };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        disable_ligatures = "never";
        cursor_shape = "beam";
        shell = "${pkgs.nushell}/bin/nu";
        editor = "${pkgs.neovide}/bin/neovide";
        background_opacity = "0.75";
        shell_integration = "enabled";
      };
      themeFile = "Duotone Dark";
    };
  };
}
