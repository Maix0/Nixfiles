{
  inputs,
  lib,
  ...
}: let
  moduleName = "cli";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      cli-nh
    ];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      cli-direnv
      cli-env
      cli-git
    ];
  };
}
