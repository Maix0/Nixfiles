{
  description = "Private Config";
  inputs = {
    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (top @ {...}: let
      inputsModules = {lib, ...}: {flake.inputs.private = lib.filterAttrs (n: _: n != "self") inputs;};
    in {
      imports =
        [inputs.flake-parts.flakeModules.modules inputsModules]
        ++ (inputs.import-tree [./nixos ./home ./packages]).imports;
      systems = ["x86_64-linux" "aarch64-linux"];
    });
}
