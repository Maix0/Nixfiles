{
  inputs,
  lib,
  ...
}: let
  moduleName = "lib-system";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    _module.args = {inherit (pkgs.stdenv.hostPlatform) system;};
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    _module.args = {inherit (pkgs.stdenv.hostPlatform) system;};
  };
}
