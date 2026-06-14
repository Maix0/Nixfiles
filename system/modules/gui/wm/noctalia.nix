{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-noctalia";
in {
  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: let
    wallpaper_image = ./files/background.png;
    avatar_image = ./files/avatar.png;
  in {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        bar.default = {
          background_opacity = 0.15;
          center = ["active_window"];
          end = ["battery" "brightness" "clock" "tray" "control-center"];
          margin_edge = 0;
          margin_ends = 0;
          radius = 0;
          shadow = false;
          start = ["launcher" "network" "bluetooth" "workspaces"];
        };

        desktop_widgets = {
          schema_version = 2;
          widget_order = ["desktop-widget-audio"];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget.desktop-widget-audio = {
            box_height = 144.0;
            box_width = 1408.0;
            cx = 720.0;
            cy = 862.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              aspect_ratio = 6.0;
              background = false;
              bands = 56.0;
              centered = false;
              high_color = "primary";
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
          enabled = false;
          schema_version = 2;
          widget_order = ["lockscreen-login-box@eDP-1"];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget."lockscreen-login-box@eDP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 720.0;
            cy = 837.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
          };
        };

        osd = {
          background_opacity = 0.6;
          position = "top_right";
        };
        shell = {
          avatar_path = avatar_image;
          font_family = "Inter Display";
          animation.speed = 2;
        };

        theme = {
          builtin = "dracula";
        };
        wallpaper.default.path = wallpaper_image;

        widget = builtins.mapAttrs (_name: value: value // {capsule = true;}) {
          active_window = {
            display = "text_only";
            max_length = 360;
            min_length = 00;
            capsule_padding = 10.0;
          };
          clock = {
            format = "{:%d/%m/%y} - {:%H:%M:%S}";
          };

          battery = {};
          brightness = {};
          date = {};
          power_profile = {};
          workspaces = {
            display = "name";
            capsule = false;
          };
        };
      };
    };
  };
}
