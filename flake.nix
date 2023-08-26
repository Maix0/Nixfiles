{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
<<<<<<< HEAD
    nixpkgs-traxys.url = "github:traxys/nixpkgs";
=======
    nixpkgs-traxys.url = "github:traxys/nixpkgs/inflight";
>>>>>>> upstream/master
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-maix = {
      url = "github:traxys/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixfiles.follows = "/";
    };
    zsh-maix = {
      url = "github:Maix0/zsh-flake";
    };
    xdg-ninja = {
      url = "github:traxys/xdg-ninja";
      flake = false;
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    naersk.url = "github:nix-community/naersk";
    nur.url = "github:nix-community/NUR";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Extra Package Sources
    kabalist = {
      url = "github:traxys/kabalist";
      flake = false;
    };
    comma.url = "github:nix-community/comma";
    raclette.url = "github:traxys/raclette";
    aseprite-flake.url = "git+ssh://git@github.com:/Maix0/aseprite-flake";
    findex-flake.url = "github:Maix0/findex-flake";

    tuxedo-nixos = {
      url = "github:blitz/tuxedo-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roaming_proxy.url = "github:traxys/roaming_proxy";
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
    fast-syntax-highlighting = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nixpkgs-traxys,
    ...
  } @ inputs: let
    sources = system:
      {
        inherit (inputs) simulationcraft kabalist;
      }
      // (nixpkgs.legacyPackages."${system}".callPackage ./_sources/generated.nix {});

    pkgList = system: callPackage:
      (import ./pkgs/default.nix {
        inherit callPackage;
        sources = sources system;
        naersk = inputs.naersk.lib."${system}";
      })
      // {
        raclette = inputs.raclette.defaultPackage."${system}";
        neovimMaix = inputs.nvim-maix.packages."${system}".nvim;
        roaming_proxy = inputs.roaming_proxy.defaultPackage."${system}";
        aseprite-flake = inputs.aseprite-flake.packages."${system}".default;
        findex = inputs.findex-flake.packages."${system}".default;
        spicetify = inputs.spicetify-nix.packages."${system}".default;
        inherit (nixpkgs-traxys.legacyPackages."${system}") djlint;
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
    };

    packages.x86_64-linux = pkgList "x86_64-linux" nixpkgs.legacyPackages.x86_64-linux.callPackage;
    packages.aarch64-linux = pkgList "aarch64-linux" nixpkgs.legacyPackages.aarch64-linux.callPackage;

    hmModules = {
      minimal = import ./minimal/hm.nix {
        inherit inputs extraInfo;
        flake = self;
      };
      personal-cli = import ./personal-cli/hm.nix;
      personal-gui = import ./personal-gui/hm.nix;
      gaming = import ./gaming/hm.nix;
      spicetify-nix = inputs.spicetify-nix.homeManagerModule;
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

    overlays.x86_64-linux = final: prev: pkgList "x86_64-linux" prev.callPackage;
    overlays.aarch64-linux = final: prev: pkgList "aarch64-linux" prev.callPackage;

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
              inputs.nix-alien.overlay
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
              (final: prev: inputs.nix-gaming.packages."${system}")
            ];
          })
          ./nixos/configuration.nix
          inputs.tuxedo-nixos.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.verbose = false;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maix = {
              config,
              lib,
              pkgs,
              ...
            }: {
              imports = [
                ./hostconfig/XeMaix/extra_info.nix
                ./hostconfig/XeMaix/hm.nix
                self.hmModules.minimal
                self.hmModules.personal-cli
                self.hmModules.personal-gui
                self.hmModules.spicetify-nix
                self.hmModules.gaming
              ];
            };
            home-manager.extraSpecialArgs = {
              flake = self;
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
