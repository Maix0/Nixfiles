{
  description = "NixOS configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      nixpkgs-mozilla = {
        url = "github:mozilla/nixpkgs-mozilla";
        flake = false;
      };
      dotacat = {
        url = "git+https://gitlab.scd31.com/stephen/dotacat.git";
        flake = false;
      };
      rnix-lsp.url = "github:nix-community/rnix-lsp";
      stylua = {
        url = "github:johnnymorganz/stylua";
        flake = false;
      };
      naersk.url = "github:nix-community/naersk";
      fast-syntax-highlighting = {
        url = "github:z-shell/fast-syntax-highlighting";
        flake = false;
      };
      zsh-nix-shell = {
        url = "github:chisui/zsh-nix-shell";
        flake = false;
      };
      nix-zsh-completions = {
        url = "github:spwhitt/nix-zsh-completions";
        flake = false;
      };
      powerlevel10k = {
        url = "github:romkatv/powerlevel10k";
        flake = false;
      };
      nvim-traxys = {
        url = "github:traxys/nvim-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = { home-manager, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.nvim-traxys.overlay."${system}"
              (import inputs.nixpkgs-mozilla)
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.traxys = import ./home.nix;
            home-manager.extraSpecialArgs = {
              dotacat = inputs.dotacat;
              rnix-lsp = inputs.rnix-lsp;
              stylua = inputs.stylua;
              naersk-lib = inputs.naersk.lib."${system}";
              fast-syntax-highlighting = inputs.fast-syntax-highlighting;
              zsh-nix-shell = inputs.zsh-nix-shell;
              nix-zsh-completions = inputs.nix-zsh-completions;
              powerlevel10k = inputs.powerlevel10k;
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
