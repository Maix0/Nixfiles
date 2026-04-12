{
  inputs,
  lib,
  ...
}: let
  moduleName = "perf";
in {
  # this doesnt really work yet, I dont really understand why
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "vimplugin-treesitter-grammar-nix"
          "nvim-treesitter"
          "yanky.nvim"
        ];
      };
    };
  };
}
