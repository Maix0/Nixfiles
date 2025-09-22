{
  pkgs,
  lib,
  config,
  myPkgs,
  ...
}: let
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
      package = pkgs.rofi;
      lockPackage = pkgs.writeShellScriptBin "lock" "${pkgs.hyprlock}/bin/hyprlock --immediate";
      exitPackage = pkgs.writeShellScriptBin "exit" "${pkgs.hyprland}/bin/hyprctl exit";
    };
  };
in {
  wayland.windowManager.hyprland = let
    tabletConfig = name: {
      inherit name;
      output = "eDP-1";
      active_area_size = "247.16, 165.24";
      active_area_position = "23.3, 0";
    };
  in {
    plugins = [
      myPkgs.hy3
    ];
    enable = true;
    settings = {
      bind = [
        ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
        ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'"
        ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'"
        ", XF86MonBrightnessDown, exec, /usr/bin/env light -U 5"
        ", XF86MonBrightnessUp, exec, /usr/bin/env light -A 5"

        "Super Shift Ctrl, Down, moveactive, 0 10 "
        "Super Shift Ctrl, Left, moveactive, -10 0"
        "Super Shift Ctrl, Right, moveactive, 10 0"
        "Super Shift Ctrl, Up, moveactive, 0 -10"

        "Super Shift, Down, hy3:movewindow, d"
        "Super Shift, Left, hy3:movewindow, l"
        "Super Shift, Right, hy3:movewindow, r"
        "Super Shift, Up, hy3:movewindow, u"

        "Super, Down, hy3:movefocus, d"
        "Super, Left, hy3:movefocus, l"
        "Super, Right, hy3:movefocus, r"
        "Super, Up, hy3:movefocus, u"

        "Super Shift, e, exit, "
        "Super Shift, q, killactive"
        "Super Shift, r, exec, ${pkgs.hyprland}/bin/hyprctl reload"

        "Super Shift, 1, movetoworkspacesilent, 1"
        "Super Shift, 2, movetoworkspacesilent, 2"
        "Super Shift, 3, movetoworkspacesilent, 3"
        "Super Shift, 4, movetoworkspacesilent, 4"
        "Super Shift, 5, movetoworkspacesilent, 5"
        "Super Shift, 6, movetoworkspacesilent, 6"
        "Super Shift, 7, movetoworkspacesilent, 7"
        "Super Shift, x, movetoworkspacesilent, 9"
        "Super Shift, z, movetoworkspacesilent, 8"

        "Super, 1, workspace, 1"
        "Super, 2, workspace, 2"
        "Super, 3, workspace, 3"
        "Super, 4, workspace, 4"
        "Super, 5, workspace, 5"
        "Super, 6, workspace, 6"
        "Super, 7, workspace, 7"
        "Super, x, workspace, 9"
        "Super, z, workspace, 8"

        "Super, Return, exec, ${config.terminal.command}"
        "Super, Escape, exec, ${rofiPackages.powermenu}/bin/rofi-powermenu"
        "Super, c, hy3:changegroup, untab"
        "Super, w, hy3:changegroup, tab"
        "Super, d, exec, ${rofiPackages.launcher}/bin/rofi-launcher"

        "Super, f, togglefloating"
        "Super Shift, f, fullscreen"
      ];
      bindl = [
        ",switch:on:Lid Switch, exec, sleep 0.1 && ${pkgs.hyprland}/bin/hyprctl dispatch dpms off"
        ",switch:off:Lid Switch, exec, sleep 0.1 && ${pkgs.hyprland}/bin/hyprctl dispatch dpms on"
      ];
      bindn = [
        ", mouse:272, hy3:focustab, mouse"
      ];

      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = false;
        };
      };
      general = {
        layout = "hy3";
        gaps_out = 0;
        gaps_in = 0;
      };
      plugin.hy3 = {
        tabs = {
          height = 20;
          padding = 5;
          rounding = 3;
          text_center = true;
          text_font = "Hack Mono";
          text_height = 10;
          text_padding = 5;
        };
      };
      workspace = [
        "1, default:true,  persistent:true "
        "2, default:false, persistent:true "
        "3, default:false, persistent:false"
        "4, default:false, persistent:false"
        "5, default:false, persistent:false"
        "6, default:false, persistent:false"
        "7, default:false, persistent:false"
        "8, default:false, persistent:true "
        "9, default:false, persistent:false"
      ];
      monitor = [
        "desc:HAT Kamvas 13 L56051794302, preferred, auto, 1, mirror, eDP-1"
        ",prefered,auto,2"
      ];

      exec-once = let
        killDbus = pkgs.writeShellScript "kill-dbus-session" ''
          ${pkgs.procps}/bin/ps aux | \
            ${pkgs.ripgrep}/bin/rg dbus | \
            ${pkgs.ripgrep}/bin/rg -v '/bin/rg' | \
            ${pkgs.ripgrep}/bin/rg -o '^'"$(${pkgs.toybox}/bin/whoami)"'\s+([0-9]+)'  --replace '$1' | \
            ${pkgs.toybox}/bin/xargs ${pkgs.procps}/bin/kill
        '';
      in [
        "${config.programs.waybar.package}/bin/waybar"
        "${killDbus}"
        "${pkgs.mako}/bin/mako"
        "${pkgs.polkit}/bin/polkit-agent-helper-1"
        "[workspace 2 silent] zen"
        "[workspace 8 silent] signal-desktop"
        "[workspace 8 silent] vesktop"
        "[workspace 2 silent] bitwarden"
        "systemctl start --user polkit-gnome-authentication-agent-1"
      ];
      device = map tabletConfig [
        "huion-huion-tablet_gs1331-pen"
        "huion-huion-tablet_gs1331-stylus"
        "huion-huion-tablet_gs1331"
      ];
      windowrule = [
        "workspace 8, class:vesktop"
        "noinitialfocus, class:vesktop"
      ];
      input.tablet = builtins.removeAttrs (tabletConfig "global tablets") ["name"];
    };
  };
}
