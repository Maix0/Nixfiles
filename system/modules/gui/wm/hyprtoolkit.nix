{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-hyprtoolkit";
in {
  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    config,
    ...
  }: let
    inherit
      (lib)
      mkIf
      mkEnableOption
      mkOption
      ;

    cfg = config.hyprtoolkit;
  in {
    options.hyprtoolkit = {
      enable = mkEnableOption "hyprtoolkit";
      settings = mkOption {
        type = with lib.types; let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Hyprland configuration value";
            };
        in
          valueType;
        default = {};
        example = {
          general.grab_focus = true;
          cache.enabled = true;
          ui.window_size = "400 260";
          finders = {
            math_prefix = "=";
            desktop_icons = true;
          };
        };
        description = ''
          Configuration settings for hyprtoolkit. All the available options can be found here:
          <https://wiki.hypr.land/Hypr-Ecosystem/hyprtoolkit/#configuration>
        '';
      };
    };

    config = mkIf cfg.enable {
      xdg.configFile."hypr/hyprtoolkit.conf" = mkIf (cfg.settings != {}) {
        text = inputs.home-manager.lib.hm.generators.toHyprconf {attrs = cfg.settings;};
      };
    };
  };
}
