{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    meson-syntax = {
      url = "github:Monochrome-Sauce/sublime-meson";
      flake = false;
    };
    xdg-ninja = {
      url = "github:traxys/xdg-ninja";
      flake = false;
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    raclette = {
      url = "github:traxys/raclette";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    aseprite-flake = {
      url = "github:maix-flake/aseprite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-maix = {
      url = "github:maix-flake/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    zshMaix = {
      url = "github:maix-flake/zsh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    rofiMaix = {
      url = "github:maix-flake/rofi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    pkgList = system: {
      raclette = inputs.raclette.packages."${system}".default;
      neovimMaix = inputs.nvim-maix.packages."${system}".nvim;
      aseprite-flake = inputs.aseprite-flake.packages."${system}".default;
      zshMaix = inputs.zshMaix.packages."${system}".default;
      hy3 = inputs.hy3.packages."${system}".default;
      buildRofi = inputs.rofiMaix.lib."${system}";
    };

    extraInfo = import ./extra_info.nix;
  in {
    templates = {
      rust = {
        path = ./templates/rust;
        description = "My rust template using rust-overlay and direnv";
      };
      perseus = {
        path = ./templates/perseus;
        description = "A perseus frontend with rust-overlay & direnv";
      };
      webapp = {
        path = ./templates/webapp;
        description = "A template for a web application (frontend + backend)";
      };
      webserver = {
        path = ./templates/webserver;
        description = "A template for a web server (using templates for the frontend)";
      };
      gui = {
        path = ./templates/gui;
        description = "A template for rust GUI applications";
      };
    };

    packages.x86_64-linux = pkgList "x86_64-linux";
    packages.aarch64-linux = pkgList "aarch64-linux";

    hmModules = {
      minimal = import ./minimal/hm.nix {
        inherit inputs extraInfo;
        flake = self;
      };
      personal-cli = import ./personal-cli/hm.nix;
      personal-gui = import ./personal-gui/hm.nix;
      gaming = import ./gaming/hm.nix;
    };

    nixosModules = {
      minimal = import ./minimal/nixos.nix {
        inherit extraInfo;
      };
      personal-cli = import ./personal-cli/nixos.nix;
      personal-gui = import ./personal-gui/nixos.nix;
      roaming = import ./roaming/nixos.nix;
      gaming = import ./gaming/nixos.nix;
    };

    overlays.x86_64-linux = final: prev: pkgList "x86_64-linux";
    overlays.aarch64-linux = final: prev: pkgList "aarch64-linux";

    nixosConfigurations = {
      XeLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/XeLaptop/hardware-configuration.nix
          ./hostconfig/XeLaptop/extra_info.nix
          ./hostconfig/XeLaptop/nixos.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          self.nixosModules.gaming
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlays.default
              inputs.hyprland.overlays.hyprland-packages #"${system}".
              inputs.hyprland.overlays.hyprland-extras #"${system}".
              inputs.hyprland-plugins.overlays.hyprland-plugins #"${system}".
              (final: prev: {
                fprintd = prev.fprintd.overrideAttrs {
                  doCheck = false;
                  dontUseMesonCheck = true;
                  postUnpack = ''
                    cat <<EOF >/build/source/tests/unittest_inspector.py
                    #! ${pkgs.runtimeShell}
                    exit 0
                    EOF
                    chmod +x /build/source/tests/unittest_inspector.py
                    ls -l /build/source/tests/unittest_inspector.py
                    cat /build/source/tests/unittest_inspector.py
                  '';
                };
              })
              (final: prev: pkgList system)
              (final: prev: inputs.nix-gaming.packages."${system}")
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = false;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.flake = self;
              users.maix = {
                config,
                lib,
                pkgs,
                ...
              }: {
                imports = [
                  ./hostconfig/XeLaptop/extra_info.nix
                  ./hostconfig/XeLaptop/hm.nix
                  self.hmModules.minimal
                  self.hmModules.personal-gui
                  self.hmModules.gaming
                ];
              };
            };
          }
        ];
      };
      XeMaix = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/XeMaix/hardware-configuration.nix
          ./hostconfig/XeMaix/extra_info.nix
          ./hostconfig/XeMaix/nixos.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          self.nixosModules.gaming
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system)
              (final: prev: inputs.nix-gaming.packages."${system}")
              (final: prev: {
                fprintd = prev.fprintd.overrideAttrs {
                  doCheck = false;
                };
              })
              (final: prev: {
                linuxPackages_xanmod_latest = nixpkgs.lib.warn "patching tuxedo-keyboard, switch to tuxedo-driver when it is stable" prev.linuxPackages_xanmod_latest.extend (lfinal: lprev: {
                  tuxedo-keyboard = lprev.tuxedo-keyboard.overrideAttrs (oldAttrs: {
                    patches = [./tuxedo-keyboard.patch];
                  });
                });
              })
            ];
          })
          ./nixos/configuration.nix
          #inputs.tuxedo-nixos.nixosModules.default # will be added back when it uses a normal nodejs version ...
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = false;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.flake = self;
              users.maix = {
                config,
                lib,
                pkgs,
                ...
              }: {
                imports = [
                  ./hostconfig/XeMaix/extra_info.nix
                  ./hostconfig/XeMaix/hm.nix
                  self.hmModules.minimal
                  self.hmModules.personal-gui
                  self.hmModules.gaming
                ];
              };
            };
          }
        ];
      };
    };
  };
}
