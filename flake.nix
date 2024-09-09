{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd.url = "github:nix-community/nixd";

    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    ags.url = "github:Aylur/ags";
  };

  outputs =
    { nixpkgs
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      paths = {
        home_modules = ./modules/home;
        sys_modules = ./modules/system;
        custom_pkgs = ./extras/packages;
        app_configs = ./extras/configs;
        wallpapers = ./extras/wallpapers;
        scripts = ./extras/scripts;
      };
      modules = {
        happypc = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system paths;
          };
          modules = [
            ./hosts/happypc/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.nix-index-database.nixosModules.nix-index
          ];
        };
        happysurface = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system paths;
          };
          modules = [
            ./hosts/happysurface/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.nix-index-database.nixosModules.nix-index
          ];
        };
      };
    in
    {
      nixosConfigurations = {
        happypc = modules.happypc;
        happysurface = modules.happysurface;
      };
      homeConfigurations = {
        happypc = modules.happypc.config.home-manager.users.happy.home;
        happysurface = modules.happysurface.config.home-manager.users.happy.home;
      };
    };
}
