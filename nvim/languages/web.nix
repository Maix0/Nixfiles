{
  inputs,
  lib,
  ...
}: let
  moduleName = "web";
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
          html
          css
          scss
        ]);
      lsp.servers = {
        cssls.enable = true;
        html.enable = true;
        lemminx.enable = true;
        djlsp = {
          enable = true;
          package = pkgs.djlint;
        };
      };
    };
  };
}
