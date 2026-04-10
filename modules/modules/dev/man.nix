{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-man";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    home.packages = with pkgs; [
      man-pages
      man-pages-posix
    ];
  };
}
