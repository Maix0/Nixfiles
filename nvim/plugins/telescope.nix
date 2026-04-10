{
  inputs,
  lib,
  ...
}: let
  moduleName = "telescope";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    lib,
    ...
  }: {
    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
    ];
    plugins = {
      telescope = {
        enable = true;
        enabledExtensions = ["ui-select"];
        settings = {
          defaults = {
            layout_strategy = "vertical";
            ui-select = lib.nixvim.mkRaw ''
              require("telescope.themes").get_dropdown {
                -- even more opts
              }
            '';
          };
        };
      };
    };
  };
}
