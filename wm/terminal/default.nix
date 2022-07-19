{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  mkColor = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
  mkColorPair = {
    normal = mkColor;
    bright = mkColor;
  };
  cfg = config.terminal;
  cCfg = cfg.colors;
in {
  imports = [./foot.nix ./kitty.nix];

  options = {
    terminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Manage terminal";
      };
      kind = mkOption {
        type = types.enum ["foot" "kitty"];
        default = "foot";
        description = "The terminal to be used";
      };
      command = mkOption {
        type = types.str;
        description = "The command used to launch the terminal";
      };
      colors = {
        background = mkOption {type = types.nullOr types.str;};
        foreground = mkColor;

        black = mkColorPair;
        red = mkColorPair;
        green = mkColorPair;
        yellow = mkColorPair;
        blue = mkColorPair;
        magenta = mkColorPair;
        cyan = mkColorPair;
        white = mkColorPair;
        alpha = mkOption {
          type = types.nullOr (types.addCheck types.float (f: f >= 0.0 && f <= 1.0)
            // {
              name = "alpha";
              description = "a float between 0.0 and 1.0 (both included)";
            });
          description = "the alpha of the background";
        };

        selectionForeground = mkColor;
      };
      font = {
        size = mkOption {
          type = types.int;
          default = 12;
          description = "terminal font size";
        };
        family = mkOption {
          type = types.str;
          default = "monospace";
          description = "font family";
        };
      };
    };
  };
}
