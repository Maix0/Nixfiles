{
  inputs,
  lib,
  ...
}: let
  moduleName = "none-ls";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {

      plugins.none-ls = {
        enable = true;
        sources.formatting = {
          sql_formatter = {
            enable = true;
            package = pkgs.sql-formatter;
          };
        };
      };
  };
}
