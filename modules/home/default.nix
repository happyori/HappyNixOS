{ ... }:
{
  imports = [
    ./git.nix
    ./shells.nix
    ./wallpapers.nix
    ./hyprland.nix
    ./terminals.nix
    ./discord.nix
    ./desktop-theming.nix
    ./utils.nix
    ./dev.nix
    ./nvidia.nix
    ./games.nix
  ];

  config = {
    xdg = {
      enable = true;
      userDirs.createDirectories = true;
    };
    home.preferXdgDirectories = true;
  };
}
