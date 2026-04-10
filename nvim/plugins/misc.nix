{
  inputs,
  lib,
  ...
}: let
  moduleName = "misc";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    plugins = {
      comment-box.enable = true;
      hex.enable = true;
      inc-rename.enable = true;
      lualine.enable = true;
      trouble.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;

      nvim-lightbulb = {
        enable = true;
        settings.autocmd.enabled = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-snippets
      markdown-preview-nvim
    ];
  };
}
