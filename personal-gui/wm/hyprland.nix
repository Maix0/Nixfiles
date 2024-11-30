{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  MyRecursiveUpdateUntil = pred: lhs: rhs: let
    f = attrPath: attrs:
      if all (a: isList a) attrs
      then flatten attrs
      else if all (a: isAttrs a) attrs
      then
        (zipAttrsWith (
          n: values: let
            here = attrPath ++ [n];
          in
            if
              length values
              == 1
              || pred here (elemAt values 1) (head values)
            then head values
            else f here values
        ))
        attrs
      else thow "must be only attrs or list at the same path";
  in
    f [] [rhs lhs];
  MyRecursiveUpdate = lhs: rhs:
    MyRecursiveUpdateUntil (path: lhs: rhs: !((isAttrs lhs && isAttrs rhs) || (isList lhs && isList rhs))) lhs rhs;
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
      id = (lists.findFirstIndex (x: x.name == name) 0 (attrsToList ws_def)) + 1;
    in [
      "${mod}, ${key}, workspace, ${toString id}"
      "${mod} ${cfg.workspaces.moveModifier}, ${key}, movetoworkspacesilent, ${toString id}"
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
      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
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
              on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
              on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
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
            "hyprland/workspaces" = let
              workspaces = attrsToList cfg.workspaces.definitions;
              indexed_workspace =
                imap (idx: w: {
                  inherit idx;
                  inherit (w) value name;
                })
                workspaces;
            in {
              numeric-first = true;
              persistent-workspaces = {
                #"*" = map (w: w.name) (filter (w: w.value.persistent) indexed_workspace);
              };
              format = "{icon}";
              format-icons = listToAttrs (map (w: {
                  name = toString w.idx;
                  value = w.name;
                })
                indexed_workspace);
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

    wm.printScreen.command = mkDefault "${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
    wm.exit.command = mkDefault "${pkgs.hyprland}/bin/hyprctl dispatch exit";

    wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hy3
      ];
      enable = true;
      settings =
        /*
        builtins.throw (builtins.toJSON
        */
        MyRecursiveUpdate {
          workspace = imap (idx: w: "${toString idx}, default:${boolToString (idx == 1)}, persistent:${boolToString w.value.persistent}") (attrsToList cfg.workspaces.definitions);
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
            };
          };
          monitor = [",prefered,auto,2"];
          exec-once = map (cmd: cmd.command) startup;
          bindl = [
            ",switch:on:Lid Switch, exec, sleep 0.1 && ${pkgs.hyprland}/bin/hyprctl dispatch dpms off"
            ",switch:off:Lid Switch, exec, sleep 0.1 && ${pkgs.hyprland}/bin/hyprctl dispatch dpms on"
          ];

          bind = common.binds;
        }
        cfg.passthru;
    };
  };
}
