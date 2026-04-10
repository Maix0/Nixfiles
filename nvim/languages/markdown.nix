{
  inputs,
  lib,
  ...
}: let
  moduleName = "markdown";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    extraPlugins = with pkgs.vimPlugins; [
      markdown-preview-nvim
    ];

    plugins.treesitter.grammarPackages =
      lib.optionals
      config.plugins.treesitter.enable
      (with config.plugins.treesitter.package.passthru.builtGrammars; [
        markdown
        markdown_inline
      ]);
  };
}
