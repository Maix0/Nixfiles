{
  inputs,
  lib,
  ...
}: let
  moduleName = "gaming";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [gaming-steam];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [gaming-lutris];
  };
}
