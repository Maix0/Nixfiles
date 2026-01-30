{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    #lix-module = {
    #  url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aseprite.url = "github:maix-flake/aseprite";
    nvimMaix.url = "github:maix-flake/nvim";
    zshMaix = {
      url = "github:maix-flake/zsh";
      # this is to force the same version of the packages
      # for example having `alias cat='${pkgs.bat}/bin/bat -p'`
      # meant that my `bat` was version 0.26, but my cat was bat 0.25
      # this caused issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofiMaix.url = "github:maix-flake/rofi";
    #rofiMaix.url = "path:/home/maix/projects/flakes/rofi";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprland.follows = "hyprland";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        aquamarine.follows = "hyprland/aquamarine";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprwire.follows = "hyprland/hyprwire";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    nh.url = "github:nix-community/nh";

    ida-pro.url = "git+ssh://forgejo@forgejo.familleboyer.net/maix/ida-pro.git";
    ida-pro-runfile = {
      url = "path:///opt/ida-pro/ida-pro_92_x64linux.run";
      flake = false;
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
      zshMaix = inputs.zshMaix.packages."${system}".default;
      rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${system}.default;
      ida-pro-runfile = inputs.ida-pro-runfile;
      hyprland = inputs.hyprland.packages.${system}.default;
      xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      hyprlandPlugins = inputs.hyprland-plugins.packages.${system};
      hyprlock = inputs.hyprlock.packages.${system}.default;
      hyprpaper = inputs.hyprpaper.packages.${system}.default;
      hyprpicker = inputs.hyprpicker.${system}.default;
      hyprshot = inputs.nixpkgs.legacyPackages.${system}.hyprshot.override {
        withFreeze = true;
        hyprland = inputs.hyprland.packages.${system}.default;
        hyprpicker = inputs.hyprpicker.packages.${system}.default;
      };
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
          inherit system;
          myPkgs = pkgList system;
          zen-browser = inputs.zen-browser;
        };
        modules = [
          inputs.nix-index-database.nixosModules.nix-index
          #inputs.lix-module.nixosModules.default
          ./nixos
          {
            nixpkgs.overlays = [
              inputs.ida-pro.overlays.default
              inputs.nh.overlays.default
              (final: prev: let
                myPkgs = pkgList system;
              in {
                inherit
                  (myPkgs)
                  hyprland
                  hyprpaper
                  hyprshot
                  hyprlock
                  xdg-desktop-portal-hyprland
                  ;
              })
              (final: prev: {
                quark-goldleaf = prev.quark-goldleaf.overrideAttrs (d-final: d-prev: rec {
                  pname = "quark-goldleaf";
                  version = "1.1.1";

                  src = final.fetchFromGitHub {
                    owner = "XorTroll";
                    repo = "Goldleaf";
                    rev = version;
                    hash = "sha256-MU+7rj0SMhWezBV/MQ6yiD3u8mNeWlsowFBo+Mi6hYI=";
                  };
                  patches = prev.lib.lists.take 2 d-prev.patches;

                  sourceRoot = "${src.name}/Quark";
                });
              })
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
                inherit system;
                myPkgs = pkgList system;
                zen-browser = inputs.zen-browser;
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
