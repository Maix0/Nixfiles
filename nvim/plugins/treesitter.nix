{
  inputs,
  lib,
  ...
}: let
  moduleName = "treesitter";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
        };
        grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
          devicetree
          diff
          dockerfile
          ini
          regex
          sql
          vim
          vimdoc
          yaml
        ];
        nixvimInjections = true;
      };

      treesitter-context.enable = true;

      ts-context-commentstring.enable = true;
      vim-matchup = {
        treesitter = {
          enable = false;
          include_match_words = false;
        };
        enable = false;
      };
    };
  };
}
