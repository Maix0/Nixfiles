{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-ghidra";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    home.packages = [pkgs.ghidra];
  };
}
