{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    aseprite.url = "github:maix-flake/aseprite";
    nvimMaix.url = "github:maix-flake/nvim";
    zshMaix.url = "github:maix-flake/zsh";
    rofiMaix.url = "github:maix-flake/rofi";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    pkgList = system: {
      aseprite = inputs.aseprite.packages."${system}".default;
      buildRofi = inputs.rofiMaix.lib."${system}";
      hy3 = inputs.hy3.packages."${system}".default;
      nvimMaix = inputs.nvimMaix.packages."${system}".default;
      zen-browser = inputs.zen-browser.packages."${system}".default;
      zshMaix = inputs.zshMaix.packages."${system}".default;
      rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${system}.default;
    };
  in {
    packages.x86_64-linux = pkgList "x86_64-linux";
    packages.aarch64-linux = pkgList "aarch64-linux";
    overlays.x86_64-linux = final: prev: pkgList "x86_64-linux";
    overlays.aarch64-linux = final: prev: pkgList "aarch64-linux";

    nixosConfigurations = {
      XeLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          flake = self;
          myPkgs = pkgList system;
        };
        modules = [
          inputs.nix-index-database.nixosModules.nix-index
          inputs.lix-module.nixosModules.default
          ./nixos
          {
            nixpkgs.overlays = [
              inputs.hyprland.overlays.hyprland-packages
              inputs.hyprland.overlays.hyprland-extras
              inputs.hyprland-plugins.overlays.hyprland-plugins
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = false;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                flake = self;
                myPkgs = pkgList system;
              };
              users.maix = {...}: {
                imports = [
                  ./home
                ];
              };
            };
          }
        ];
      };
    };
  };
}
