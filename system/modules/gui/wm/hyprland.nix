{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-hyprland";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      gui-hyprlock
    ];
  };

  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      gui-hypridle
      gui-hyprlock
      gui-hyprpaper
      gui-mako
      gui-waybar
    ];

    wayland.windowManager.hyprland = let
      inherit (inputs.hyprland.packages.${system}) hyprland;
      tabletConfig = name: {
        inherit name;
        output = "eDP-1";
        active_area_size = "247.16, 165.24";
        active_area_position = "23.3, 0";
      };
    in {
      package = hyprland;
      plugins = [];
      enable = true;
      settings = {
        bind = [
          ", Print, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only"
          ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'"
          ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'"
          ", XF86MonBrightnessUp, exec, /usr/bin/env brightnessctl s 5%+"
          ", XF86MonBrightnessDown, exec, /usr/bin/env brightnessctl s 5%-"

          "Super Ctrl, Down, moveactive, 0 100 "
          "Super Ctrl, Left, moveactive, -100 0"
          "Super Ctrl, Right, moveactive, 100 0"
          "Super Ctrl, Up, moveactive, 0 -100"

          "Super Shift, Left, layoutmsg, swapcol l"
          "Super Shift, Right, layoutmsg, swapcol r"

          "Super Shift, Up , layoutmsg, colresize +0.2"
          "Super Shift, Down, layoutmsg, colresize -0.2"

          "Super, Down, layoutmsg, focus d"
          "Super, Left, layoutmsg, focus l"
          "Super, Right, layoutmsg, focus r"
          "Super, Up, layoutmsg, focus u"

          "Super Shift, e, exit, "
          "Super Shift, q, killactive"
          "Super Shift, r, exec, ${hyprland}/bin/hyprctl reload"

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

          "Super, Return, exec, ${lib.getExe pkgs.foot}"
          #"Super, Escape, exec, ${rofiPackages.powermenu}/bin/rofi-powermenu"
          "Super, c, layoutmsg, togglefit"
          "Super, d, exec, ${lib.getExe pkgs.hyprlauncher}"

          "Super, f, togglefloating"
          "Super Shift, f, fullscreen"
        ];
        bindl = [
          ",switch:on:Lid Switch, exec, sleep 0.1 && ${hyprland}/bin/hyprctl dispatch dpms off"
          ",switch:off:Lid Switch, exec, sleep 0.1 && ${hyprland}/bin/hyprctl dispatch dpms on"
        ];
        bindn = [
          #", mouse:272, hy3:focustab, mouse"
        ];

        input = {
          kb_layout = "us";
          touchpad = {
            natural_scroll = false;
          };
        };
        general = {
          layout = "scrolling";
          gaps_out = 0;
          gaps_in = 0;
        };
        scrolling = {
          column_width = 0.8;
          fullscreen_on_one_column = true;
          focus_fit_method = 1;
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

        monitorv2 = let
          mkTopMonitor = output: {
            inherit output;
            mode = "preferred";
            position = "0x0";
            scale = "1";
          };
        in [
          {
            output = "desc:HAT Kamvas 13 L56051794302";
            mode = "preferred";
            position = "auto";
            scale = "1";
            mirror = "eDP-1";
          }
          (mkTopMonitor "desc:Lenovo Group Limited P27h-30")
          (mkTopMonitor "desc:HP Inc. OMEN by HP 27 CNK908129J")
          {
            output = "desc:BOE NE135A1M-NY1";
            mode = "preferred";
            position = "0x1440";
            scale = "2";
          }
        ];

        exec-once = let
          killDbus = pkgs.writeShellScript "kill-dbus-session" ''
            ${pkgs.procps}/bin/ps aux | \
              ${lib.getExe pkgs.ripgrep} dbus | \
              ${lib.getExe pkgs.ripgrep} -v '/bin/rg' | \
              ${lib.getExe pkgs.ripgrep} -o '^'"$(${pkgs.toybox}/bin/whoami)"'\s+([0-9]+)'  --replace '$1' | \
              ${pkgs.toybox}/bin/xargs ${pkgs.procps}/bin/kill
          '';
        in [
          "${lib.getExe pkgs.waybar}"
          "${killDbus}"
          "${lib.getExe pkgs.mako}"
          "${pkgs.polkit}/bin/polkit-agent-helper-1"
          "[workspace 2 silent] zen-twilight"
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
          {
            name = "vesktop-workspace";
            "match:class" = "vesktop";
            workspace = 8;
            no_initial_focus = true;
          }
        ];
        input.tablet = builtins.removeAttrs (tabletConfig "global tablets") ["name"];
      };
    };
  };
}
