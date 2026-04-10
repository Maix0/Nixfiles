{
  inputs,
  lib,
  ...
}: let
  moduleName = "_template";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {};
}
