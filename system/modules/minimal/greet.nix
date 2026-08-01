{
  inputs,
  lib,
  ...
}: let
  moduleName = "min-greet";
in {
  flake.modules.nixos.${moduleName} = {
    pkgs,
    system,
    config,
    ...
  }: let
    inherit (inputs.hyprland.packages.${system}) hyprland;
    cfg = config.maix.greeter.tui;
  in {
    options.maix.greeter.tui = {
      enable = lib.mkEnableOption "Enable tui-greet";
      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
        description = "--theme command line argument";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          message = "Only a single maix.greeter can be enabled at the same time !";
          assertion =
            (
              builtins.foldl' (acc: v:
                acc
                + (
                  if v
                  then 1
                  else 0
                ))
              0 (builtins.attrValues (builtins.mapAttrs (n: o:
                if builtins.hasAttr "enable" o
                then o.enable
                else false)
              config.maix.greeter))
            )
            == 1;
        }
      ];
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --user-menu -rt ${lib.strings.optionalString (cfg.theme != null) "--theme ${lib.escapeShellArg cfg.theme}"}";
            user = "greeter";
          };
        };
      };
      environment.systemPackages = [hyprland];
      environment.variables = {
        XDG_DATA_DIRS = ["${hyprland}/share"];
      };
    };
  };
}
