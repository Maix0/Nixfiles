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
        assertion = inputs.self.lib.containsModule "private-dev-ida" inputs.self.modules.homeManager;
        message = "You need to provide an private implementation for the `dev-ida` module";
      }
    ];
    imports = inputs.self.lib.optionalModule "private-dev-ida" inputs.self.modules.homeManager;
  };
}
