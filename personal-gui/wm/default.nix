{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}: {
  imports = [./terminal ./i3like.nix];

  wm = let
    mod = config.wm.modifier;
    rofiPackages = myPkgs.buildRofi.mkRofiPackages {
      config.rofi = {
        launcher = {
          enable = true;
          style = 2;
          theme = 2;
        };
        powermenu = {
          enable = true;
          style = 2;
          theme = 2;
        };
        package = pkgs.rofi-wayland;
        lockPackage = pkgs.writeShellScriptBin "lock" "${pkgs.hyprlock}/bin/hyprlock --immediate";
        exitPackage = pkgs.writeShellScriptBin "exit" "${pkgs.hyprland}/bin/hyprctl exit";
      };
    };
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
      command = "${rofiPackages.launcher}/bin/rofi-launcher";
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
      {command = "${lib.optionalString (config.wm.kind == "hyprland") "[workspace 9 silent]"} signal-desktop";}
      {command = "${lib.optionalString (config.wm.kind == "hyprland") "[workspace 2 silent]"} zen";}
      {command = "${lib.optionalString (config.wm.kind == "hyprland") " [workspace 9 silent]"} vesktop";}
      {command = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";}
      {command = "${pkgs.polkit}/bin/polkit-agent-helper-1";}
      {command = "systemctl start --user polkit-gnome-authentication-agent-1";}
    ];

    workspaces = {
      moveModifier = "Shift";
      definitions = {
        "1:" = {
          key = "1";
          persistent = true;
        };
        "2:" = {
          key = "2";
          persistent = true;
        };
        "3:" = {key = "3";};
        "4" = {key = "4";};
        "5" = {key = "5";};
        "6" = {key = "6";};
        "7" = {key = "7";};
        "" = {key = "x";};
        "" = {
          key = "z";
          persistent = true;
        };
      };
    };

    keybindings = {
      "${mod}+Escape" = "${rofiPackages.powermenu}/bin/rofi-powermenu";
      "XF86PowerOff" = "${rofiPackages.powermenu}/bin/rofi-powermenu";
      "XF86AudioRaiseVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
      "XF86AudioLowerVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
      "XF86AudioMute" = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86MonBrightnessDown" = "/usr/bin/env light -U 5";
      "XF86MonBrightnessUp" = "/usr/bin/env light -A 5";

      "${mod}+Return" = "${config.terminal.command}";
      "${mod}+Shift+S" = "${config.programs.rofi.package}/bin/rofi -show ssh";
    };
    passthru = let
      tabletConfig = name: {
        inherit name;
        output = "eDP-1";
        active_area_size = "247.16, 165.24";
        active_area_position = "23.3, 0";
      };
    in {
      env = [
        "HYPRCURSOR_THEME, rose-pine-hyprcursor"
      ];
      bindn = [
        ", mouse:272, hy3:focustab, mouse"
      ];
      bind = [
        "${mod} Shift Ctrl, Left, moveactive, -10 0"
        "${mod} Shift Ctrl, Right, moveactive, 10 0"
        "${mod} Shift Ctrl, Up, moveactive, 0 -10"
        "${mod} Shift Ctrl, Down, moveactive, 0 10 "
        "${mod}, Left, hy3:movefocus, l"
        "${mod}, Right, hy3:movefocus, r"
        "${mod}, Down, hy3:movefocus, d"
        "${mod}, Up, hy3:movefocus, u"
        "${mod} Shift, Left, hy3:movewindow, l"
        "${mod} Shift, Right, hy3:movewindow, r"
        "${mod} Shift, Down, hy3:movewindow, d"
        "${mod} Shift, Up, hy3:movewindow, u"
        "${mod}, f, togglefloating"
        "${mod} Shift, f, fullscreen"
        "${mod}, w, hy3:changegroup, tab"
        "${mod}, c, hy3:changegroup, untab"
        "${mod} Shift, q, killactive"
        "${mod} Shift, r, exec, ${pkgs.hyprland}/bin/hyprctl reload"
      ];
      device = map tabletConfig [
        "huion-huion-tablet_gs1331-pen"
        "huion-huion-tablet_gs1331-stylus"
        "huion-huion-tablet_gs1331"
      ];
      monitor = [
        "desc:HAT Kamvas 13 L56051794302, preferred, auto, 1, mirror, eDP-1"
      ];
      input.tablet = builtins.removeAttrs (tabletConfig "global tablets") ["name"];
    };
  };
}
