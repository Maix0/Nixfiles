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
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    LIBSEAT_BACKEND = "logind";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      alpha = 0.80;
      background = "0F0F0F";
      selectionForeground = "000000";
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = 10;
    };
  };

  wm = let
    mod = config.wm.modifier;
  in {
    enable = true;
    kind = "sway";
    modifier = "Mod4";

    font = {
      name = "Hack Nerd Font";
      style = "Regular";
      size = 13.0;
    };
    bar = {
      font = {
        name = "Hack Nerd Font Mono";
        style = "Regular";
        size = 13.0;
      };
    };

    wallpaper = "/home/maix/wallpaper.jpg"; #""${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";

    printScreen = {
      enable = true;
      keybind = "Print";
    };

    menu = {
      enable = true;
      keybind = "${mod}+d";
    };

    exit = {
      enable = true;
      keybind = "${mod}+Shift+e";
    };

    notifications = {
      enable = true;
      font = "hack nerd font 14";
      defaultTimeout = 7000;
    };

    startup = [
      {command = "signal-desktop";}
      {command = "discord";}
      {command = "firefox";}
      {command = "spotify";}
      {command = "element-desktop";}
      {command = "thunderbird";}
      {command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
    ];

    workspaces = {
      moveModifier = "Shift";
      definitions = {
        "1:" = {key = "ampersand";};
        "2:" = {
          key = "eacute";
        };
        "3:" = {key = "quotedbl";};
        "4" = {key = "apostrophe";};
        "5" = {key = "parenleft";};
        "6" = {key = "minus";};
        "7" = {key = "egrave";};
        "" = {
          key = "less";
          output = "HDMI-0";
          assign = ["Spotify"];
        };
        "" = {
          key = "w";
          assign = [
            "Element"
            "Signal"
            "Discord"
          ];
        };
        "" = {
          key = "x";
          assign = ["Thunderbird"];
        };
      };
    };

    keybindings = {
      "${mod}+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";

      # Media Keys
      "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
      "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
      "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
      "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next";
      "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous";

      # Focus
      "${mod}+Left" = "focus left";
      "${mod}+Right" = "focus right";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Right" = "move right";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";

      # Layout
      "${mod}+f" = "fullscreen toggle";
      "${mod}+z" = "layout tabbed";
      "${mod}+c" = "layout toggle split";

      # Misc
      "${mod}+Shift+a" = "kill";
      "${mod}+Shift+R" = "reload";
      "${mod}+Return" = "exec ${config.terminal.command}";
      "${mod}+p" = "mode resize";
      "${mod}+Shift+P" = "restart";
    };
  };
}
