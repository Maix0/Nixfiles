{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./terminal ./i3like.nix];

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    LIBSEAT_BACKEND = "logind";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    NIXPKGS_ALLOW_UNFREE = 1;
  };

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

  programs.foot.settings.colors."16" = "ff9e64";
  programs.foot.settings.colors."17" = "db4b4b";

  home.sessionVariables = {
    EXA_COLORS = "xx=38;5;8";
  };

  wm = let
    mod = config.wm.modifier;
  in {
    enable = true;
    kind = "hyprland";
    modifier = "Super";

    font = {
      name = "Hack";
      style = "Regular";
      size = 10.0;
    };
    bar = {
      font = {
        name = ["Hack"];
        style = "Regular";
        size = 10.0;
      };
    };

    wallpaper = null; # ../../wallpapers/wallpaper.jpg;

    printScreen = {
      enable = true;
      keybind = "Print";
    };

    menu = {
      enable = true;
      keybind = "${mod}+d";
      command = "${pkgs.rofi-wayland}/bin/rofi -show drun";
    };

    exit = {
      enable = true;
      keybind = "${mod}+Shift+e";
    };

    notifications = {
      enable = true;
      font = "hack nerd font 10";
      defaultTimeout = 7000;
    };

    startup = [
      {command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {command = "signal-desktop";}
      {command = "firefox";}
      {command = "findex-daemon";}
      {command = "vesktop";}
      {command = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";}
    ];

    workspaces = {
      moveModifier = "Shift";
      definitions = {
        "1:" = {key = "1";};
        "2:" = {key = "2";};
        "3:" = {key = "3";};
        "4" = {key = "4";};
        "5" = {key = "5";};
        "6" = {key = "6";};
        "7" = {key = "7";};
        "" = {key = "x";};
        "" = {key = "z";};
      };
    };

    keybindings = {
      "${mod}+Escape" = "exec ${pkgs.hyprlock}/bin/hyprlock";

      # Media Keys
      "XF86AudioRaiseVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
      "XF86AudioLowerVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
      "XF86AudioMute" = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioPlay" = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
      "${mod}+Alt+Right" = "${pkgs.playerctl}/bin/playerctl -p spotify next"; # Mod + Alt + Right
      "${mod}+Alt+Left" = "${pkgs.playerctl}/bin/playerctl -p spotify previous"; # Mod + Alt + Left
      "XF86MonBrightnessDown" = "/usr/bin/env light -U 5";
      "XF86MonBrightnessUp" = "/usr/bin/env light -A 5";

      # Focus
      "${mod}+Left" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movefocus l";
      "${mod}+Right" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movefocus r";
      "${mod}+Down" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movefocus d";
      "${mod}+Up" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movefocus u";
      "${mod}+Shift+Left" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movewindow l";
      "${mod}+Shift+Right" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movewindow r";
      "${mod}+Shift+Down" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movewindow d";
      "${mod}+Shift+Up" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:movewindow u";

      # Layout
      "${mod}+f" = "${pkgs.hyprland}/bin/hyprctl dispatch fullscreen";
      "${mod}+w" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:changegroup tab";
      "${mod}+c" = "${pkgs.hyprland}/bin/hyprctl dispatch hy3:changegroup untab";

      # Misc
      "${mod}+Shift+q" = "${pkgs.hyprland}/bin/hyprctl dispatch killactive";
      "${mod}+Shift+R" = "${pkgs.hyprland}/bin/hyprctl reload";
      "${mod}+Return" = "${config.terminal.command}";
      "${mod}+Shift+S" = "${config.programs.rofi.package}/bin/rofi -show ssh";
    };
  };
}
