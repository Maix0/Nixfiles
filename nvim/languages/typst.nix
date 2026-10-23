{
  inputs,
  lib,
  ...
}: let
  moduleName = "tyspt";
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
          typst
        ]);
      lsp.servers.tinymist.enable = true;
      typst-preview.enable = true;
    };
  };
}
