{
  description = "NixOS configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixpkgs-mozilla = {
        url = "github:mozilla/nixpkgs-mozilla";
        flake = false;
      };
      nvim-maix = {
        url = "github:maix/nvim-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      zsh-mauix = {
        url = "github:maix/zsh-flake";
      };
    };

  outputs = { home-manager, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      ZeMaix = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.nvim-maix.overlay."${system}"
              (import inputs.nixpkgs-mozilla)
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maix = { config, lib, pkgs, ... }: {
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
