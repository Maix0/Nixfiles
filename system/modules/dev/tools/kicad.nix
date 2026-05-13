{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-kicad";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, system, ...}: {
    home.packages = [inputs.self.packages.${system}.kicad_9];
  };
}
