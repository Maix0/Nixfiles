{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-ida";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {};

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    assertions = [
      {
        assertion = true;
        message = "ida module not yet ported!";
      }
    ];
  };
}
