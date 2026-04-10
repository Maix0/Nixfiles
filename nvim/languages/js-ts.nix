{
  inputs,
  lib,
  ...
}: let
  moduleName = "js-ts";
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
          javascript
          jsdoc
          json
          typescript
        ]);
      lsp.servers = {
        eslint.enable = true;
        ts_ls.enable = true;
      };
    };
  };
}
