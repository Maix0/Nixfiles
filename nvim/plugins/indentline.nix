{
  inputs,
  lib,
  ...
}: let
  moduleName = "indentline";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    highlight = {
      IndentBlanklineIndent1 = {
        fg = "#E06C75";
        nocombine = true;
      };
      IndentBlanklineIndent2 = {
        fg = "#E5C07B";
        nocombine = true;
      };
      IndentBlanklineIndent3 = {
        fg = "#98C379";
        nocombine = true;
      };
      IndentBlanklineIndent4 = {
        fg = "#56B6C2";
        nocombine = true;
      };
      IndentBlanklineIndent5 = {
        fg = "#61AFEF";
        nocombine = true;
      };
      IndentBlanklineIndent6 = {
        fg = "#C678DD";
        nocombine = true;
      };
    };

    plugins.indent-blankline = {
      enable = true;

      settings.scope = {
        enabled = true;
        show_start = true;
      };
    };
  };
}
