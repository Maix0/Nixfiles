{
  description = "Config";
  inputs = {
    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    privateConfig = {
      url = "path:./stubPrivate";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (top @ {...}: let
      inputsModules = {lib, ...}: {flake.inputs.public = lib.filterAttrs (n: _: n != "self") inputs;};
      privateModules = {lib, ...}: {
        flake.modules = inputs.privateConfig.modules;

        perSystem = {system, ...}: {
          apps = inputs.privateConfig.apps.${system};
          packages = inputs.privateConfig.packages.${system};
        };
      };
    in {
      imports =
        [inputs.flake-parts.flakeModules.modules inputsModules privateModules]
        ++ (inputs.import-tree [./system ./nvim ./packages]).imports;
      systems = ["x86_64-linux" "aarch64-linux"];
    });
}
