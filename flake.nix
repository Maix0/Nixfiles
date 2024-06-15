{
  description = "NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-index-database.follows = "nix-index-database";
        flake-utils.follows = "flake-utils";
      };
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-maix = {
      url = "github:Maix0/nvim-flake";
      inputs = {
        #nixpkgs.follows = "nixpkgs";
        #flake-utils.follows = "flake-utils";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comma = {
      url = "github:nix-community/comma";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raclette = {
      url = "github:traxys/raclette";
      inputs = {
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    xdg-ninja = {
      url = "github:traxys/xdg-ninja";
      flake = false;
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Extra Package Sources
    meson-syntax = {
      url = "github:Monochrome-Sauce/sublime-meson";
      flake = false;
    };
    aseprite-flake = {
      url = "git+ssh://git@github.com:/Maix0/aseprite-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    findex-flake = {
      url = "github:Maix0/findex-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        naersk.follows = "naersk";
      };
    };
    zshMaix = {
      url = "github:Maix0/zsh-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        naersk.follows = "naersk";
      };
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
      findex = inputs.findex-flake.packages."${system}".default;
      zshMaix = inputs.zshMaix.packages."${system}".default;
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
