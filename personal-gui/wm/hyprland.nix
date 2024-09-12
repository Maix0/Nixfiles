{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.wm;
  common = let
    addKeyIf = cond: keybinds: newkey:
      if cond
      then newkey ++ keybinds
      else keybinds;

    keybindSolo = keys: submod:
      addKeyIf submod.enable keys (let
        keybind_splited = strings.splitString "+" submod.keybind;
        mods = lists.init keybind_splited;
        key = last keybind_splited;
      in [
        "${builtins.concatStringsSep " " mods}, ${key}, exec, ${submod.command}"
      ]);
    keydefs = [cfg.menu cfg.printScreen];
    keybindingsKeydef = foldl' keybindSolo (foldl' (x: y: x ++ y) [] (map ({
      name,
      value,
    }:
      keybindSolo [] {
        enable = true;
        keybind = name;
        command = value;
      }) (lib.attrsToList cfg.keybindings)))
    keydefs;

    mod = cfg.modifier;
    ws_def = cfg.workspaces.definitions;
    get_ws = ws: getAttr ws ws_def;
    workspaceFmt = name: let
      inherit (get_ws name) key;
    in [
      "${mod}, ${key}, workspace, name:${name}"
      "${mod} ${cfg.workspaces.moveModifier}, ${key}, movetoworkspacesilent, name:${name}"
    ];
  in {
    binds =
      (foldl' (x: y: x ++ y) [] (map workspaceFmt (attrNames ws_def)))
      ++ keybindingsKeydef
      ++ (
        if cfg.exit.enable
        then
          (let
            keybind_splited = strings.splitString "+" cfg.exit.keybind;
            mods = lists.init keybind_splited;
            key = last keybind_splited;
          in [
            "${builtins.concatStringsSep " " mods}, ${key}, exit, "
          ])
        else []
      );
  };

  startupNotifications =
    if cfg.notifications.enable
    then [
      {
        command = "${pkgs.mako}/bin/mako";
      }
    ]
    else [];

  startup = startupNotifications ++ cfg.startup ++ [{command = "${pkgs.waybar}/bin/waybar";}];
in {
  config = mkIf (cfg.enable && cfg.kind == "hyprland") {
    home.packages = with pkgs;
      [
        hyprland
        wofi
      ]
      ++ (
        if cfg.wallpaper != null
        then [pkgs.hyprpaper]
        else []
      );

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };
          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      hyprpaper = mkIf (cfg.wallpaper != null) {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;
          splash_offset = 2.0;
          preload = ["${cfg.wallpaper}"];
          wallpaper = [
            ",${cfg.wallpaper}"
          ];
        };
      };
      mako = mkIf cfg.notifications.enable {
        inherit (cfg.notifications) defaultTimeout font;
        enable = true;
        margin = "20,20,5,5";
        extraConfig = ''
          [mode=do-not-disturb]
          invisible=1
        '';
      };
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = false;
            grace = 60;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = "\'<span foreground=\"##cad3f5\">Password...</span>'";
              shadow_passes = 2;
            }
          ];
        };
      };
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
              "hyprland/workspaces"
            ];
            modules-center = ["hyprland/window"];
            modules-right = [
              "backlight"
              "pulseaudio"
              "cpu"
              "memory"
              "disk#home"
              "battery"
              "clock"
              "tray"
            ];
            "hyprland/workspaces" = {
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
            "hyprland/window" = {
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
    wm.exit.command = mkDefault "${pkgs.hyprland}/bin/hyprctl dispatch exit";

    wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hy3
        #pkgs.hyprbars
      ];
      enable = true;
      settings = {
        workspace = imap (idx: w: "name:${w}, default:${boolToString (idx == 0)}") (attrNames cfg.workspaces.definitions);
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
            #text_font = "${cfg.font.name}";
          };
        };
        exec-once = map (cmd: cmd.command) startup;
        bind = common.binds;
        # inherit (cfg) modifier;
        # inherit startup;
        # bars = [{command = "waybar";}];
        # output = config.extraInfo.outputs;
        # fonts = common.mkFont cfg.font;
        # window = {
        #  titlebar = false;
        #  commands = [
        #    {
        #      criteria.class = "davmail-DavGateway";
        #      command = "floatin enable";
        #    }
        #    {
        #      criteria.window_type = "menu";
        #      command = "floating enable";
        #    }
        #  ];
        #};
      };
    };
  };
}
