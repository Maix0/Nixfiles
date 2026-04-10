{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-nvim";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {};

  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    home.packages = [
      inputs.nvim.packages.${system}.default
    ];
  };
}
