{
  inputs,
  lib,
  ...
}: let
  moduleName = "comment";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    plugins.comment = {
      enable = true;
      settings = {
        mappings = {
          extra = false;
          basic = false;
        };
        pre_hook = "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
      };
      settings.toggler.line = "<C-/>";
    };
  };
}
