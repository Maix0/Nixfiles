{
  inputs,
  lib,
  ...
}: let
  moduleName = "bigFileOptimizer";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    autoGroups.BigFileOptimizer = {};
    autoCmd = [
      {
        event = "BufReadPost";
        pattern = [
          "*.md"
          "*.rs"
          "*.lua"
          "*.sh"
          "*.bash"
          "*.zsh"
          "*.js"
          "*.jsx"
          "*.ts"
          "*.tsx"
          "*.c"
          "*.h"
          "*.cc"
          "*.hh"
          "*.cpp"
          "*.cph"
        ];
        group = "BigFileOptimizer";
      }
    ];
  };
}
