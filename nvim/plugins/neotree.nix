{
  inputs,
  lib,
  ...
}: let
  moduleName = "noetree";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    plugins.neo-tree.enable = true;
    globals.neo_tree_remove_legacy_commands = 1;
  };
}
