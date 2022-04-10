{ config, lib, pkgs, ... }:

{
  imports = [ ./terminal ];

  home.packages = with pkgs; [
    sway
  ];

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    LIBSEAT_BACKEND = "logind";
  };

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      background = "000000";
      foreground = "ffffff";

      black = {
        normal = "000000";
        bright = "545454";
      };
      red = { normal = "ff5555"; };
      green = { normal = "55ff55"; };
      yellow = { normal = "ffff55"; };
      blue = { normal = "5555ff"; };
      magenta = { normal = "ff55ff"; };
      cyan = { normal = "55ffff"; };
      white = {
        normal = "bbbbbb";
        bright = "ffffff";
      };

      selectionForeground = "000000";
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = 7;
    };
  };

  programs = {
    mako = {
      enable = true;
      font = "hack nerd font 10";
      margin = "20,20,5,5";
      ignoreTimeout = true;
      defaultTimeout = 7000;
    };

    waybar = {
      enable = true;
      style = builtins.readFile ./waybar.css;
      settings = [
        {
          layer = "top";
          position = "bottom";
          modules-left = [
            "network#wifi"
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [ "sway/window" ];
          modules-right = [
            "cpu"
            "memory"
            "disk#home"
            "disk#root"
            "battery"
            "clock"
            "tray"
          ];
          modules = {
            "sway/workspaces" = {
              persistent_workspaces = {
                "" = [ ];
                "" = [ ];
                "1:" = [ ];
              };
              numeric-first = true;
            };
            "network#wifi" = {
              interface = "wlp1s0";
              format-wifi = "{essid} ({signalStrength}%) ";
            };
            cpu = {
              format = "﬙ {load}";
            };
            memory = {
              format = " {used:.0f}G/{total:.0f}G";
            };
            "sway/window" = {
              max-length = 50;
            };
            "disk#home" = {
              path = "/home";
              format = " {free}";
            };
            "disk#root" = {
              path = "/";
              format = " {percentage_free}%";
            };
            "battery" = {
              format = "{capacity}% {icon}";
              format-icons = [ "" "" "" "" "" ];
            };
            "clock" = {
              format-alt = "{:%a, %d. %b  %H:%M}";
            };
          };
        }
      ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      bars = [{
        command = "waybar";
      }];
      input =
        let
          inputs = config.extraInfo.inputs;
          inputsCfg = [
            (if inputs.keyboard != null then {
              name = inputs.keyboard;
              value =
                {
                  xkb_layout = "us";
                  xkb_variant = "dvp";
                  xkb_options = "compose:102";
                };

            } else null)
            (if inputs.touchpad != null then {
              name = inputs.touchpad;
              value = { dwt = "disable"; };
            } else null)
          ];
        in
        builtins.listToAttrs inputsCfg;
      fonts = {
        names = [ "Hack Nerd Font" ];
        style = "Regular";
        size = 13.0;
      };
      window = {
        titlebar = true;
      };
      startup = [
        { command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "wdumpkeys >> ~/.keydump"; }
      ];
      menu = "${pkgs.wofi}/bin/wofi --show drun,run --allow-images";
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          menu = config.wayland.windowManager.sway.config.menu;
          terminal = config.wayland.windowManager.sway.config.terminal;
          ws1 = "1:";
          ws2 = "2:";
          ws3 = "3";
          ws4 = "4:";
          ws5 = "5";
          ws6 = "6";
          ws7 = "7";
          ws8 = "8";
          ws9 = "";
          ws10 = "";
        in
        {
          "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
          "${mod}+Shift+semicolon" = "kill";
          "${mod}+e" = "exec ${menu}";
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 50 toggle";

          "${mod}+u" = "fullscreen toggle";
          "${mod}+comma" = "layout tabbed";
          "${mod}+p" = "mode resize";

          "${mod}+h" = "focus left";
          "${mod}+t" = "focus down";
          "${mod}+n" = "focus up";
          "${mod}+s" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+Shift+H" = "move left";
          "${mod}+Shift+T" = "move down";
          "${mod}+Shift+N" = "move up";
          "${mod}+Shift+S" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          # Workspaces
          "${mod}+ampersand" = "workspace ${ws1}";
          "${mod}+bracketleft" = "workspace ${ws2}";
          "${mod}+braceleft" = "workspace ${ws3}";
          "${mod}+braceright" = "workspace ${ws4}";
          "${mod}+parenleft" = "workspace ${ws5}";
          "${mod}+equal" = "workspace ${ws6}";
          "${mod}+asterisk" = "workspace ${ws7}";
          "${mod}+parenright" = "workspace ${ws8}";
          "${mod}+w" = "workspace ${ws9}";
          "${mod}+m" = "workspace ${ws10}";
          "${mod}+Shift+ampersand" = "move container to workspace ${ws1}";
          "${mod}+Shift+bracketleft" = "move container to workspace ${ws2}";
          "${mod}+Shift+braceleft" = "move container to workspace ${ws3}";
          "${mod}+Shift+braceright" = "move container to workspace ${ws4}";
          "${mod}+Shift+parenleft" = "move container to workspace ${ws5}";
          "${mod}+Shift+equal" = "move container to workspace ${ws6}";
          "${mod}+Shift+asterisk" = "move container to workspace ${ws7}";
          "${mod}+Shift+parenright" = "move container to workspace ${ws8}";
          "${mod}+Shift+w" = "move container to workspace ${ws9}";
          "${mod}+Shift+m" = "move container to workspace ${ws10}";

          "${mod}+Shift+J" = "reload";
          "${mod}+Shift+p" = "restart";
          "${mod}+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
        };
    };

  };

  home.file = {
    ".config/wofi/" = {
      source = ./wofi;
      recursive = true;
    };
  };
}