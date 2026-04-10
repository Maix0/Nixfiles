{
  inputs,
  lib,
  ...
}: let
  moduleName = "clipboard";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    clipboard.providers.wl-copy.enable = true;
  };
}
