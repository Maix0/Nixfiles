{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-noctalia";
in {
  flake.modules.nixos.${moduleName} = {
    pkgs,
    system,
    config,
    ...
  }: let
    cfg = config.maix.greeter.noctalia;
  in {
    options.maix.greeter.noctalia = {
      enable = lib.mkEnableOption "Enable noctalia-greeter";
      assertions = [
        {
          message = "Only a single maix.greeter can be enabled at the same time !";
          assertion =
            (
              builtins.foldl' (acc: v:
                acc
                + (
                  if v
                  then 1
                  else 0
                ))
              0 (builtins.attrValues (builtins.mapAttrs (n: o:
                if builtins.hasAttr "enable" o
                then o.enable
                else false)
              config.maix.greeter))
            )
            == 1;
        }
      ];
    };
    config = lib.mkIf cfg.enable {
      #programs.noctalia-greeter = {
      #enable = true;
      # Optional: extra flags after `--` on noctalia-greeter-session
      #greeter-args = "";
      # Full declarative greeter.toml (overwritten each activation). See examples/greeter.toml.
      #settings = {
      #  cursor = {
      #    theme = "Bibata-Modern-Ice";
      #    size = 24;
      #    path = "${pkgs.bibata-cursors}/share/icons";
      #  };
      #};
      #};
    };
  };

  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    imports = [
      #inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        bar.default = {
          background_opacity = 0.15;
          center = ["active_window"];
          end = ["battery" "brightness" "clock" "tray"];
          margin_edge = 0;
          margin_ends = 0;
          radius = 0;
          shadow = false;
          start = ["network" "bluetooth" "workspaces"];
        };

        desktop_widgets = {
          schema_version = 2;
          widget_order = ["audio"];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget.audio = {
            box_height = 144.0;
            box_width = 1408.0;
            cx = 720.0;
            cy = 862.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              background = false;
              bands = 56.0;
              centered = false;
              color_1 = "primary";
              color_2 = "primary";
              mirrored = true;
              show_when_idle = true;
            };
          };
        };

        idle = {
          behavior_order = ["lock" "screen-off" "lock-and-suspend"];
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 600;
            };
            lock-and-suspend = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 900;
            };
            screen-off = {
              action = "screen_off";
              enabled = true;
              timeout = 660;
            };
          };
        };
        location.address = "Paris";
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = ["login-box" "clock" "weather" "audio"];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            login-box = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 720.0;
              cy = 837.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "login_box";
            };

            clock = {
              box_height = 96.0;
              box_width = 192.0;
              cx = 720.0;
              cy = 192.0;
              output = "eDP-1";
              placement_height = 960.0;
              placement_width = 1440.0;
              rotation = 0.0;
              type = "clock";
            };

            weather = {
              box_height = 176.0;
              box_width = 192.0;
              cx = 720.0;
              cy = 352.0;
              output = "eDP-1";
              placement_height = 960.0;
              placement_width = 1440.0;
              rotation = 0.0;
              type = "weather";
              settings.show_forecast = true;
            };

            audio = {
              box_height = 144.0;
              box_width = 1408.0;
              cx = 720.0;
              cy = 862.0;
              output = "eDP-1";
              placement_height = 960.0;
              placement_width = 1440.0;
              rotation = 0.0;
              type = "audio_visualizer";
              settings = {
                background = false;
                bands = 56.0;
                centered = false;
                color_1 = "primary";
                color_2 = "primary";
                mirrored = true;
                show_when_idle = true;
              };
            };
          };
        };

        osd = {
          background_opacity = 0.6;
          position = "top_right";
        };
        shell = {
          avatar_path = ./files/avatar.png;
          font_family = "Inter Display";
          animation.speed = 2;

          launcher = {
            category_icons_only = true;
            layout = "simple";
          };
          session.actions = [
            {
              action = "lock";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "1";
              variant = "default";
            }

            {
              action = "logout";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "2";
              variant = "default";
            }

            {
              action = "lock_and_suspend";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "3";
              variant = "default";
            }
            {
              action = "command";
              command = "${lib.getExe' pkgs.systemd "systemctl"} soft-reboot";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "reboot";
              label = "Soft Reboot";
              shortcut = "s";
              variant = "default";
            }
            {
              action = "reboot";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "5";
              variant = "destructive";
            }
          ];
        };

        theme = {
          builtin = "Tokyo-Night";
          community_palette = "Oxocarbon";
          mode = "dark";
        };
        wallpaper = {
          fill_mode = "crop";
          enabled = true;
          transition = ["fade" "wipe" "disc" "stripes" "zoom" "honeycomb"];
          directory = ./files/background/.;

          automation = {
            enabled = true;
            order = "random";
            interval_seconds = 1800;
            recursive = true;
          };
        };

        widget = builtins.mapAttrs (_name: value: value // {capsule = true;}) {
          active_window = {
            display = "text_only";
            max_length = 360;
            min_length = 00;
            capsule_padding = 10.0;
            interactive = false;
          };
          clock = {
            format = "{:%d/%m/%y} - {:%H:%M:%S}";
          };

          battery = {};
          brightness = {};
          date = {};
          power_profile = {};
          workspaces = {
            label_source = "name";
            capsule = false;
          };
        };
        calendar = {
          enabled = true;

          account.personal = {
            name = "Personal";
            path = "/home/maix/.calendar";
            type = "vdir";
          };
          account.holydays = {
            color = "error";
            name = "Holydays";
            server_url = "https://etalab.github.io/jours-feries-france-data/ics/jours_feries_metropole.ics";
            type = "ics";
          };
        };
      };
    };
  };
}
