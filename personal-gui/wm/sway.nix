{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.wm;
  common = import ./i3like-utils.nix {inherit config;};

  startupNotifications =
    if cfg.notifications.enable
    then [
      {
        command = "${pkgs.mako}/bin/mako";
        always = true;
      }
    ]
    else [];

  startup = startupNotifications ++ cfg.startup;
in {
  config = mkIf (cfg.enable && cfg.kind == "sway") {
    home.packages = with pkgs;
      [
        sway
        rofi-wayland
      ]
      ++ (
        if cfg.wallpaper != null
        then [pkgs.swaybg]
        else []
      );

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    programs.rofi.package = pkgs.rofi-wayland;

    services.mako = mkIf cfg.notifications.enable {
      enable = true;
      font = cfg.notifications.font;
      margin = "20,20,5,5";
      defaultTimeout = cfg.notifications.defaultTimeout;
      extraConfig = ''
        [mode=do-not-disturb]
        invisible=1
      '';
    };

    programs = {
      waybar = {
        enable = true;
        style = builtins.readFile ./waybar.css;
        settings = [
          {
            layer = "top";
            position = "top";
            modules-left = [
              "bluetooth"
              "network#wifi"
              "sway/workspaces"
              "sway/mode"
            ];
            modules-center = ["sway/window"];
            modules-right = [
              "backlight"
              "pulseaudio"
              "cpu"
              "memory"
              "disk#home"
              # "disk#root"
              "battery"
              "clock"
              "tray"
            ];
            "sway/workspaces" = {
              persistent-workspaces = {
                "" = [];
                "" = [];
                "1:" = [];
              };
              numeric-first = true;
            };
            "network#wifi" = {
              interface = "wlp1s0";
              format-wifi = "{essid} ({signalStrength}%) ";
            };
            cpu = {
              format = "󰘚 {load}";
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
              format-icons = ["" "" "" "" ""];
            };
            "clock" = {
              format-alt = "{:%a, %d. %b  %H:%M}";
            };
          }
        ];
      };
    };

    wm.printScreen.command = mkDefault "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
    wm.exit.command = mkDefault "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

    wayland.windowManager.sway = {
      enable = true;
      extraConfig = mkIf (cfg.wallpaper != null) ''
        output "*" bg ${cfg.wallpaper} fill
        input * xkb_layout "us"
      '';
      config = {
        inherit startup;
        modifier = cfg.modifier;
        bars = [
          {
            command = "waybar";
          }
        ];
        input = let
          inputs = config.extraInfo.inputs;
          inputsCfg = [
            (
              if inputs.touchpad != null
              then {
                name = inputs.touchpad;
                value = {dwt = "disable";};
              }
              else null
            )
          ];
        in
          builtins.listToAttrs (builtins.filter (s: s != null) inputsCfg);
        output = config.extraInfo.outputs;
        fonts = common.mkFont cfg.font;
        window = {
          titlebar = false;
          commands = [
            {
              criteria.class = "davmail-DavGateway";
              command = "floatin enable";
            }
            {
              criteria.window_type = "menu";
              command = "floating enable";
            }
          ];
        };
        keybindings = common.keybindings;
        workspaceOutputAssign = common.workspaceOutputAssign;
        assigns = common.assigns;
      };
    };
  };
}
