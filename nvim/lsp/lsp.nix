{
  inputs,
  lib,
  ...
}: let
  moduleName = "lsp";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    plugins = {
      lspkind = {
        enable = true;
        cmp.enable = true;
      };
      luasnip = {
        enable = true;
        autoLoad = true;
      };
      lsp = {
        enable = true;
        inlayHints = true;

        keymaps = {
          silent = true;
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "<leader>a" = "code_action";
            "ff" = "format";
            "K" = "hover";
          };
        };

        servers = {
          nginx_language_server.enable = true;
          
          efm.extraOptions = {
            enable = true;
            init_options.documentFormatting = true;
            settings.logLevel = 1;
          };
        };
      };
    };
  };
}
