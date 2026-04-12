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
      inputs.self.packages.${system}.nvim
    ];
  };
}
