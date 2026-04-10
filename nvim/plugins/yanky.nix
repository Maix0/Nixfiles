{
  inputs,
  lib,
  ...
}: let
  moduleName = "yanky";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, ...}: {
    plugins.yanky = {
      enable = true;
      enableTelescope = true;
      settings.picker.telescope.use_default_mappings = true;
    };
  };
}
