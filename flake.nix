{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:Mic92/nix-ld/main";
    nvim-maix = {
      url = "github:Maix0/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
    kabalist = {
      url = "github:traxys/kabalist";
      flake = false;
    };
    comma.url = "github:nix-community/comma";
    raclette.url = "github:traxys/raclette";
  };
  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      ZeMaix = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.rust-overlay.overlays.default
              inputs.nvim-maix.overlay."${system}"
              # inputs.nix-alien.overlay
              inputs.comma.overlays.default
              (final: prev: {
                xdg-ninja = with pkgs;
                  stdenv.mkDerivation rec {
                    pname = "xdg-ninja";
                    version = "0.1";
                    src = inputs.xdg-ninja;
                    installPhase = ''
                      mkdir -p $out/bin
                      cp xdg-ninja.sh $out/bin
                      cp -r programs $out/bin
                      wrapProgram $out/bin/xdg-ninja.sh \
                      	--prefix PATH : ${lib.makeBinPath [bash jq glow]}
                    '';
                    buildInputs = [jq glow bash];
                    nativeBuildInputs = [makeWrapper];
                  };
                kabalist_cli = inputs.naersk.lib."${system}".buildPackage {
                  cargoBuildOptions = opts: opts ++ ["--package=kabalist_cli"];
                  root = inputs.kabalist;
                };
                raclette = inputs.raclette.defaultPackage."${system}";
              })
            ];
          })
          ./nixos/configuration.nix
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
                ./home.nix
                ./graphical.nix
                ./extra_info.nix
                ./localinfo.nix
                ./wm
                ./rustdev.nix
                ./git
                inputs.zsh-maix.home-managerModule."${system}"
                inputs.nvim-maix.home-managerModule."${system}"
              ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
