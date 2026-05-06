{
  inputs,
  lib,
  ...
}: let
  moduleName = "p-stub";
in {
  # flake.modules.homeManager.${moduleName} = {pkgs, ...}: {};
}
