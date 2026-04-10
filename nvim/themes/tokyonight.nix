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
      options.nixvim.tokyonight = {
        enable = mkEnableOption "Enable Tokyonight";
      };

      config = let
        cfg = config.nixvim.tokyonight;
      in
        mkIf cfg.enable {
          colorschemes.tokyonight = {
            settings.style = "night";
            enable = true;
          };
        };
    };
}
