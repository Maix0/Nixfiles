{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "git+ssh://git@github.com:/nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld = {
      url = "git+ssh://git@github.com:/Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-maix = {
      url = "git+ssh://git@github.com:/Maix0/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-maix = {
      url = "git+ssh://git@github.com:/Maix0/zsh-flake";
    };
    xdg-ninja = {
      url = "git+ssh://git@github.com:/traxys/xdg-ninja";
      flake = false;
    };
    rust-overlay.url = "git+ssh://git@github.com:/oxalica/rust-overlay";
    naersk.url = "git+ssh://git@github.com:/nix-community/naersk";
    kabalist = {
      url = "git+ssh://git@github.com:/traxys/kabalist";
      flake = false;
    };
    comma.url = "git+ssh://git@github.com:/nix-community/comma";
    raclette.url = "git+ssh://git@github.com:/traxys/raclette";
    aseprite-flake.url = "git+ssh://git@github.com:/Maix0/aseprite-flake";
    findex-flake.url = "git+ssh://git@github.com:/Maix0/findex-flake";

    tuxedo-nixos = {
      url = "git+ssh://git@github.com:/blitz/tuxedo-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "git+ssh://git@github.com:/the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      XeMaix = nixpkgs.lib.nixosSystem rec {
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
                  stdenv.mkDerivation {
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
                aseprite-flake = inputs.aseprite-flake.packages."${system}".default;
                findex = inputs.findex-flake.defaultPackage."${system}";
                spicetify = inputs.spicetify-nix.packages."${system}".default;
              })
              (final: prev: {
                httpie = prev.httpie.overrideAttrs (oldAttrs: {
                  doCheck = false;
                  doInstallCheck = false;
                });
              })
              (final: prev: {
                python310Packages = prev.python310Packages.overrideScope (pfinal: pprev: {
                  httpie = pprev.httpie.overrideAttrs (oldAttrs: {
                    doCheck = false;
                    doInstallCheck = false;
                  });
                });
              })
              (final: prev: {
                python39Packages = prev.python39Packages.overrideScope (pfinal: pprev: {
                  httpie = pprev.httpie.overrideAttrs (oldAttrs: {
                    doCheck = abort false;
                    doInstallCheck = false;
                  });
                });
              })
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
                inputs.spicetify-nix.homeManagerModule
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
