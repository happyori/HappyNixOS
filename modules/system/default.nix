{ ... }: {
  imports = [
    ./one-pass.nix
    ./dev.nix
    ./greet.nix
    ./fonts.nix
    ./nvidia.nix
    ./steam.nix
    ./vpn.nix
  ];
}
