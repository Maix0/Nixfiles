{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-hyprlauncher";
in {
  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [gui-hyprtoolkit];

    hyprtoolkit = {
      enable = true;
      settings = {
        h1_size = 25;
        h2_size = 20;
        h3_size = 17;
        font_size = 15;
        small_font_size = 14;
        font_family = "Hack Nerd";
        font_family_monospace = "Hack Nerd Mono";
        background = "rgb(15,12,22)";
        base = "rgb(33,26,46)";
        alternate_base = "rgb(43,34,59)";

        text = "rgb(242,233,255)";
        bright_text = "rgb(255,255,255)";

        accent = "rgb(211,134,255)";
        accent_secondary = "rgb(224,92,168)";
      };
    };

    services = {
      hyprlauncher = {
        enable = true;
        settings = {
          ui = {
            window_size = "500 400";
          };
        };
      };
    };
  };
}
