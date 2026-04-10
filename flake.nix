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

    aseprite.url = "github:maix-flake/aseprite";
    nvim.url = "github:maix-flake/nvim";
    zsh = {
      url = "github:maix-flake/zsh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (top @ {...}: {
      imports =
        [inputs.flake-parts.flakeModules.modules]
        ++ (inputs.import-tree [./system ./nvim ./packages]).imports;
      systems = ["x86_64-linux" "aarch64-linux"];
    });
}
