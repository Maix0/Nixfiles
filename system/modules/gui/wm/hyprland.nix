{inputs, ...}: let
  moduleName = "gui-hyprland";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      # gui-hyprlock
    ];
  };

  flake.modules.homeManager.${moduleName} = {
    lib,
    pkgs,
    system,
    ...
  }: let
    toLua = lib.generators.toLua {multiline = false;};
  in {
    imports = with inputs.self.modules.homeManager; [
      # gui-hypridle
      # gui-hyprlock
      # gui-hyprpaper
      gui-hyprlauncher
      # gui-mako
      gui-noctalia
    ];

    wayland.windowManager.hyprland = let
      inherit (inputs.hyprland.packages.${system}) hyprland;
      tabletConfig = name: {
        inherit name;
        output = "eDP-1";
        active_area_size = "247.16, 165.24";
        active_area_position = "23.3, 0";
      };
      workspaces = [
        {
          name = "";
          persistent = true;
        }
        {
          name = "";
          persistent = true;
        }
        {name = "";}
        {}
        {}
        {}
        {}
        {
          name = "";
          persistent = true;
          key = "z";
        }
        {
          name = "";
          key = "x";
        }
      ];

      mvAmount = 100;

      mkLuaFunction = {
        name,
        args,
      }:
        lib.generators.mkLuaInline "${name}(${
          builtins.concatStringsSep ", " (builtins.map toLua (
            if builtins.isList args
            then args
            else [args]
          ))
        })";

      mkRawBind = key: name: args: {
        _args = [
          key
          (mkLuaFunction {inherit args name;})
        ];
      };

      mkExecBind = key: action:
        mkRawBind key "hl.dsp.exec_cmd" action;
      mkMoveRelBind = key: x: y:
        mkRawBind key "hl.dsp.window.move" {
          inherit x y;
          relative = true;
        };
      mkLayoutMsgBind = key: msg:
        mkRawBind key "hl.dsp.layout" msg;

      timer = duration: code:
        lib.generators.mkLuaInline ''
          function()
            hl.timer(function()
              ${code}
            end, ${lib.generators.toLua {
            timeout = duration;
            type = "oneshot";
          }})
          end)
        '';

      exec-once = let
        killDbus = pkgs.writeShellScript "kill-dbus-session" ''
          ${lib.getExe' pkgs.procps "ps"} aux | \
            ${lib.getExe pkgs.ripgrep} dbus | \
            ${lib.getExe pkgs.ripgrep} -v '/bin/rg' | \
            ${lib.getExe pkgs.ripgrep} -o '^'"$(${lib.getExe' pkgs.toybox "whoami"})"'\s+([0-9]+)'  --replace '$1' | \
            ${lib.getExe' pkgs.toybox "xargs"} ${lib.getExe' pkgs.procps "kill"}
        '';
      in [
        "${killDbus}"
        "noctalia"
        "${lib.getExe' pkgs.polkit "polkit-agent-helper-1"}"
        "zen-twilight"
        "signal-desktop"
        "sleep 60 && vesktop"
        "bitwarden"
        "systemctl start --user polkit-gnome-authentication-agent-1"
      ];
    in {
      package = hyprland;
      plugins = [];
      enable = true;
      configType = "lua";
      settings = {
        bind =
          [
            (mkExecBind "Print" "${lib.getExe pkgs.hyprshot} -m region --clipboard-only")
            (mkExecBind "XF86AudioLowerVolume" "${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ '-10%'")
            (mkExecBind "XF86AudioMute" "${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-mute @DEFAULT_SINK@ toggle")
            (mkExecBind "XF86AudioRaiseVolume" "${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ '+10%'")
            (mkExecBind "XF86MonBrightnessUp" "/usr/bin/env brightnessctl s 5%+")
            (mkExecBind "XF86MonBrightnessDown" "/usr/bin/env brightnessctl s 5%-")

            (mkMoveRelBind "SUPER+CTRL+Down" 0 mvAmount)
            (mkMoveRelBind "SUPER+CTRL+Up" 0 (-mvAmount))
            (mkMoveRelBind "SUPER+CTRL+Left" (-mvAmount) 0)
            (mkMoveRelBind "SUPER+CTRL+Right" mvAmount 0)

            (mkLayoutMsgBind "SUPER+SHIFT+Left" "swapcol l")
            (mkLayoutMsgBind "SUPER+SHIFT+Right" "swapcol r")

            (mkLayoutMsgBind "SUPER+SHIFT+Up" "colresize +0.2")
            (mkLayoutMsgBind "SUPER+SHIFT+Down" "colresize -0.2")

            (mkLayoutMsgBind "SUPER+Down" "focus d")
            (mkLayoutMsgBind "SUPER+Left" "focus l")
            (mkLayoutMsgBind "SUPER+Right" "focus r")
            (mkLayoutMsgBind "SUPER+Up" "focus u")

            (mkRawBind "SUPER+SHIFT+e" "hl.dsp.exit" [])

            (mkRawBind "SUPER+SHIFT+q" "hl.dsp.window.close" [])

            (mkExecBind "SUPER+SHIFT+e" "${lib.getExe' hyprland "hyprctl"} reload")

            (mkExecBind "SUPER+Return" "${lib.getExe pkgs.foot}")

            (mkExecBind "SUPER+Space" "noctalia msg session lock")
            (mkExecBind "SUPER+Escape" "noctalia msg panel-toggle session")
            (mkExecBind "SUPER+d" "noctalia msg panel-toggle launcher")

            (mkRawBind "SUPER+f" "hl.dsp.window.float" {action = "toggle";})
            (mkRawBind "SUPER+SHIFT+f" "hl.dsp.window.fullscreen" {action = "toggle";})
          ]
          ++ (lib.flatten (lib.imap (idx: {
              name ? null,
              persistent ? false,
              key ? "${toString idx}",
            }: let
              wName =
                if (name == null)
                then "${toString idx}"
                else "name:${name}";
            in [
              (mkRawBind "SUPER+SHIFT+${key}" "hl.dsp.window.move" {
                workspace = "${toString idx}";
                follow = false;
              })
              (mkRawBind "SUPER+${key}" "hl.dsp.focus" {workspace = "${toString idx}";})
            ])
            workspaces))
          #++ (builtins.map ({_args}: {_args = _args ++ [{locked = true;}];}) [
          #(mkRawBind "switch:on:Lid Switch"
          #  (timer 500 "hl.dispatch(hl.dsp.dpms(${toLua {action = "disable";}}))"))
          #(mkRawBind "switch:on:Lid Switch"
          #  (timer 500 "hl.dispatch(hl.dsp.dpms(${toLua {action = "enable";}}))"))
          #])
          ;
        config = {
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
          input.tablet = builtins.removeAttrs (tabletConfig "global tablets") ["name"];
        };

        workspace_rule =
          lib.imap (idx: {
            name ? null,
            persistent ? false,
            key ? "${idx}",
          }: let
            wName =
              if (name == null)
              then "${toString idx}"
              else "${name}";
          in {
            inherit persistent;
            workspace = toString idx;
            default = idx == 1;
            default_name = wName;
          })
          workspaces;

        monitor = let
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
            scale = 1;
            mirror = "eDP-1";
          }
          (mkTopMonitor "desc:Lenovo Group Limited P27h-30")
          (mkTopMonitor "desc:HP Inc. OMEN by HP 27 CNK908129J")
          {
            output = "desc:BOE NE135A1M-NY1";
            mode = "preferred";
            position = "0x1440";
            scale = 2;
          }
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
        ];

        device = map tabletConfig [
          "huion-huion-tablet_gs1331-pen"
          "huion-huion-tablet_gs1331-stylus"
          "huion-huion-tablet_gs1331"
        ];
        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                ${builtins.concatStringsSep "\n" (builtins.map (x: "hl.exec_cmd(${toLua x})") exec-once)}
              end
            '')
          ];
        };
      };
    };
  };
}
