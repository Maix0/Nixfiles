{
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        tuitheme = "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
      in {
        command = "${pkgs.tuigreet}/bin/tuigreet --user-menu -rt --theme ${lib.escapeShellArg tuitheme}";
        user = "greeter";
      };
    };
  };
  environment.systemPackages = [pkgs.hyprland];
  environment.variables = {
    XDG_DATA_DIRS = ["${pkgs.hyprland}/share"];
  };
}
