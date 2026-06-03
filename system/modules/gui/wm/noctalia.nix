{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-noctalia";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: let
    wallpaper = ./files/background.png;
  in {
    imports = [inputs.noctalia.homeModules.default];

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = wallpaper;
      };
    };

    programs.noctalia-shell = {
      enable = true;
      package = pkgs.noctalia-shell.override {calendarSupport = true;};
      settings = lib.importJSON ./files/config.json;
    };
  };
}
