{
  inputs,
  lib,
  ...
}: let
  moduleName = "shell";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    plugins = {
      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          bash
          fish
        ]);
      lsp.servers.bashls.enable = true;
    };
  };
}
