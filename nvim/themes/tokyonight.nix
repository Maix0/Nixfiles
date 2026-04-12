{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixvim.tokyonight = {
    pkgs,
    config,
    ...
  }:
    with lib; {
      colorschemes.tokyonight = {
        settings.style = "night";
        enable = true;
      };
    };
}
