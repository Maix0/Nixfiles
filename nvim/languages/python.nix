{
  inputs,
  lib,
  ...
}: let
  moduleName = "python";
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
          python
          toml
        ]);
      lsp.servers = {
        jedi_language_server.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        taplo.enable = true;
      };
    };
  };
}
