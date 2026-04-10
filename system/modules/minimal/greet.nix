{
  inputs,
  lib,
  ...
}: let
  moduleName = "min-greet";
in {
  flake.modules.nixos.${moduleName} = {pkgs, system, ...}: let
    inherit (inputs.hyprland.packages.${system}) hyprland;
  in {
    services.greetd = {
      enable = true;
      settings = {
        default_session = let
          tuitheme = "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
        in {
          command = "${lib.getExe pkgs.tuigreet} --user-menu -rt --theme ${lib.escapeShellArg tuitheme}";
          user = "greeter";
        };
      };
    };
    environment.systemPackages = [hyprland];
    environment.variables = {
      XDG_DATA_DIRS = ["${hyprland}/share"];
    };
  };
}
