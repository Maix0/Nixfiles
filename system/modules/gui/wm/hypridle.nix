{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-hypridle";
in {
  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    services = let
      inherit (inputs.hyprland.packages.${system}) hyprland;
    in {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "${hyprland}/bin/hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "${lib.getExe pkgs.hyprlock}";
          };
          listener = [
            {
              timeout = 900;
              on-timeout = "${lib.getExe pkgs.hyprlock}";
            }
            {
              timeout = 1200;
              on-timeout = "${hyprland}/bin/hyprctl dispatch dpms off";
              on-resume = "${hyprland}/bin/hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
