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
      size = lib.mkDefault 13;
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
    kind = "sway";
    modifier = "Mod4";

    font = {
      name = ["Hack"];
      style = "Regular";
      size = 13.0;
    };
    bar = {
      font = {
        name = ["Hack"];
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
      command = "echo '' > $HOME/.config/findex/toggle_file";
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
      {command = "signal-desktop";}
      {command = "vesktop";}
      {command = "firefox";}
      #{command = "spotify";}
      {command = "findex-daemon";}
      {command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {
        command = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";
        always = true;
      }
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
      "${mod}+Escape" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";

      # Media Keys
      "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
      "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
      "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
      "${mod}+Mod1+Right" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next"; # Mod + Alt + Right
      "${mod}+Mod1+Left" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous"; # Mod + Alt + Left
      "XF86MonBrightnessDown" = "exec /run/wrappers/bin/light -U 5";
      "XF86MonBrightnessUp" = "exec /run/wrappers/bin/light -A 5";

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
      "${mod}+Shift+S" = "exec ${config.programs.rofi.package}/bin/rofi -show ssh";
    };
  };
}
