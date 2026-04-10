{
  inputs,
  lib,
  ...
}: let
  moduleName = "c-cpp";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    filetype.extension = {
      c__TEMPLATE__ = "c";
      h__TEMPLATE__ = "c";
    };
    plugins = {
      headerguard.enable = true;
      clangd-extensions = {
        enable = true;
        enableOffsetEncodingWorkaround = true;

        settings = {
          inlay_hints = {
            right_align = true;
            right_align_padding = 4;
            inline = false;
          };
          ast = {
            role_icons = {
              type = "";
              declaration = "";
              expression = "";
              specifier = "";
              statement = "";
              templateArgument = "";
            };
            kind_icons = {
              compound = "";
              recovery = "";
              translationUnit = "";
              packExpansion = "";
              templateTypeParm = "";
              templateTemplateParm = "";
              templateParamObject = "";
            };
          };
        };
      };

      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          c
          cpp
          make
          meson
          ninja
        ]);
      lsp.servers.clangd.enable = true;
    };
  };
}
