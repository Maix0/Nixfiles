{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-hyprpaper";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    services.hyprpaper = {
      settings = {
        preload = ["${./files/background.png}"];
        wallpaper = [
          {
            monitor = "";
            path = "${./files/background.png}";
          }
        ];
        ipc = true;
        splash = true;
      };
      enable = true;
    };
  };
}
