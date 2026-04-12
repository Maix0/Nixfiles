{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-foot";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = [inputs.self.modules.nixos.gui-fonts];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    programs.foot = {
      enable = true;
      settings = {
        colors-dark = {
          alpha = "0.800000";
          "16" = "ff9e64";
          "17" = "db4b4b";
          background = "0F0F0F";
          foreground = "c0caf5";

          selection-background = "33467c";
          selection-foreground = "c0caf5";

          bright0 = "414868";
          bright1 = "f7768e";
          bright2 = "9ece6a";
          bright3 = "e0af68";
          bright4 = "7aa2f7";
          bright5 = "bb9af7";
          bright6 = "7dcfff";
          bright7 = "c0caf5";

          regular0 = "15161e";
          regular1 = "f7768e";
          regular2 = "9ece6a";
          regular3 = "e0af68";
          regular4 = "7aa2f7";
          regular5 = "bb9af7";
          regular6 = "7dcfff";
          regular7 = "a9b1d6";
          urls = "73daca";
        };
        main.font = "Hack Nerd Font Mono:size=10";
      };
    };
  };
}
