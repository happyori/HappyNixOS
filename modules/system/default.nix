{ ... }:
{
  imports = [
    ./one-pass.nix
    ./dev.nix
    ./mounting.nix
    ./greet.nix
    ./fonts.nix
    ./nvidia.nix
    ./steam.nix
    ./vpn.nix
    ./amdgpu.nix
  ];
}
