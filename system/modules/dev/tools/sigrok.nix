{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-sigrok";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    services.udev = {
      enable = true;
      packages = [pkgs.libsigrok];
    };
  };

  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
  };
}
