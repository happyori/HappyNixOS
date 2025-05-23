{
  pkgs,
  config,
  ...
}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    loadInNixShell = true;
  };
  environment.etc."direnv/direnv.toml" = {
    text = ''
      [global]
      warn_timeout = "2m"
      hide_env_diff = true
    '';
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.dive
    pkgs.podman-compose
  ];

  hardware.nvidia-container-toolkit.enable = config.custom.hardware.nvidia.enable;
}
