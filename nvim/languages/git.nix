{
  inputs,
  lib,
  ...
}: let
  moduleName = "git";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    plugins = {
      gitsigns.enable = true;
      gitmessenger.enable = true;

      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          gitattributes
          gitcommit
          gitignore
          git_rebase
        ]);
    };
  };
}
