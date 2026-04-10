{
  inputs,
  lib,
  ...
}: let
  moduleName = "options";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    opts = {
      termguicolors = true;
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      scrolloff = 7;
      signcolumn = "yes";
      cmdheight = 2;
      cot = ["menu" "menuone" "noselect"];
      updatetime = 100;
      colorcolumn = "80";
      spell = false;
      list = true;
      listchars = "tab:󰁔 ,lead:·,nbsp:␣,trail:•";
      fsync = true;

      timeout = true;
      timeoutlen = 300;
    };
    globals.mapleader = " ";
    extraConfigLuaPre = ''
      vim.lsp.inlay_hint.enable(true)
    '';
  };
}
