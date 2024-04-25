{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd = {
      url = "github:nix-community/nixd";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
      paths = {
        home_modules = ./modules/home;
        sys_modules = ./modules/system;
        custom_pkgs = ./extras/packages;
        app_configs = ./extras/configs;
        wallpapers = ./extras/wallpapers;
      };
    in
    {
      nixosConfigurations.happypc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit unstable-pkgs;
          inherit system;
          inherit paths;
        };
        modules = [
          ./hosts/happypc/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.nix-index-database.nixosModules.nix-index
        ];
      };
    };
}
