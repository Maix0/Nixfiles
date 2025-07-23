{lib, ...}: {
  import = [./terminal];

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      alpha = 0.80;
      background = "0F0F0F";
      foreground = "c0caf5";

      black = {
        normal = "15161e";
        bright = "414868";
      };
      red = {normal = "f7768e";};
      green = {normal = "9ece6a";};
      yellow = {normal = "e0af68";};
      blue = {normal = "7aa2f7";};
      magenta = {normal = "bb9af7";};
      cyan = {normal = "7dcfff";};
      white = {
        normal = "a9b1d6";
        bright = "c0caf5";
      };

      urls = "73daca";

      selection = {
        foreground = "c0caf5";
        background = "33467c";
      };
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = lib.mkDefault 10;
    };
  };

  programs.foot.settings.colors = {
    "16" = "ff9e64";
    "17" = "db4b4b";
  };
}
