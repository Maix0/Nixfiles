{
  inputs,
  lib,
  ...
}: let
  moduleName = "_template";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {};

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {};
}
