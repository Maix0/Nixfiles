{
  inputs,
  lib,
  ...
}: let
  moduleName = "stub";
in {
  # flake.modules.nixos.${moduleName} = {pkgs, ...}: {};
}
