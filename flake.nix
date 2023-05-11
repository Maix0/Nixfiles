{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    simulationcraft = {
      url = "github:simulationcraft/simc";
      flake = false;
    };
    oscclip = {
      url = "github:rumpelsepp/oscclip";
      flake = false;
    };
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
    dotacat = {
      url = "git+https://gitlab.scd31.com/stephen/dotacat.git";
      flake = false;
    };
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

  outputs = inputs: let
    nixpkgs = inputs.nixpkgs;
    home-manager = inputs.home-manager;
    self = inputs.self;
    sources =
      {
        inherit (inputs) oscclip simulationcraft kabalist dotacat;
      }
      // (nixpkgs.legacyPackages.x86_64-linux.callPackage ./_sources/generated.nix {});

    pkgList = system: callPackage:
      (import ./pkgs/default.nix {
        inherit sources callPackage;
        naersk = inputs.naersk.lib."${system}";
      })
      // {
        raclette = inputs.raclette.defaultPackage."${system}";
        neovimMaix = inputs.nvim-maix.packages."${system}".nvim;
        roaming_proxy = inputs.roaming_proxy.defaultPackage."${system}";
        aseprite-flake = inputs.aseprite-flake.packages."${system}".default;
        findex = inputs.findex-flake.defaultPackage."${system}";
        spicetify = inputs.spicetify-nix.packages."${system}".default;
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
    };

    packages.x86_64-linux = pkgList "x86_64-linux" nixpkgs.legacyPackages.x86_64-linux.callPackage;

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

    overlays.x86_64-linux = final: prev: pkgList "x86_64-linux" prev.callPackage;

    nixosConfigurations = {
      XeMaix = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
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
              inputs.nix-gaming.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
            ];
          })
          ./nixos/configuration.nix
          inputs.tuxedo-nixos.nixosModules.default
          home-manager.nixosModules.home-manager
          {
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
                ./hostconfig/XeMaix/hardware-configuration.nix
                ./hostconfig/XeMaix/nixos.nix
                self.hmModules.minimal
                self.hmModules.personal-cli
                self.hmModules.personal-gui
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
