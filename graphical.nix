{ pkgs, config, ... }:

let
  localinfo = import ./localinfo.nix;
in
{
  home.packages = with pkgs; [
	bitwarden
    firefox-wayland
    /* firefox */
    thunderbird-wayland
    element-desktop
    (discord.override { nss = pkgs.nss; })
    spotify
    signal-desktop
    libreoffice-fresh
    feh
	alacritty
    # (tor-browser-bundle-bin.override {
    #  useHardenedMalloc = false;
    # })

    sway
    xdg_utils
  ];
	
  # xdg.mime.defaultApplications = { "text/x-csharp" = "nvim-unity.desktop"; };
  xdg.desktopEntries = {
	nvim-unity = {
		name = "nvim-unity";
		exec = "/home/maix/bin/nvim-unity %f";
		terminal = true;
		mimeType = ["text/x-csharp"];

	};
  };

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

  /* programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
    extraPolicies = {
    ExtensionSettings = { };
    };
    };
    }; */

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    BROWSER = "firefox";
    LIBSEAT_BACKEND = "logind";
  	_JAVA_AWT_WM_NONREPARENTING=1;
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
          position = "top";
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

    zathura = {
      enable = true;
    };

  };



  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      bars = [{
        command = "waybar";
      }];
      input = {
        "${localinfo.keyboard}" = {
          xkb_layout = "fr";
        };
        "${localinfo.touchpad}" = {
          dwt = "disable";
        };
      };
      fonts = {
        names = [ "Hack Nerd Font" ];
        style = "Regular";
        size = 13.0;
      };
      window = {
        titlebar = false;
      };
      startup = [
        { command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "wdumpkeys >> ~/.keydump"; }
      ];
      menu = "${pkgs.wofi}/bin/wofi --show drun,run --allow-images";
      terminal = "${pkgs.foot}/bin/foot";
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
          ws9 = "";
          ws10 = "";
        in
        {
          "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
          "${mod}+Shift+A" = "kill";
          "${mod}+d" = "exec ${menu}";
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+E" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${mod}+f" = "fullscreen toggle";
          "${mod}+z" = "layout tabbed";
          "${mod}+c" = "layout toggle split";
          "${mod}+r" = "mode resize";

          "${mod}+j" = "focus left";
          "${mod}+k" = "focus down";
          "${mod}+l" = "focus up";
          "${mod}+m" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+Shift+J" = "move left";
          "${mod}+Shift+K" = "move down";
          "${mod}+Shift+L" = "move up";
          "${mod}+Shift+M" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          # Workspaces
          "${mod}+ampersand" = "workspace ${ws1}";
          "${mod}+less" = "workspace ${ws1}";
          "${mod}+eacute" = "workspace ${ws2}";
          "${mod}+Control_L" = "workspace ${ws2}";
          "${mod}+quotedbl" = "workspace ${ws3}";
          "${mod}+apostrophe" = "workspace ${ws4}";
          "${mod}+parenleft" = "workspace ${ws5}";
          "${mod}+minus" = "workspace ${ws6}";
          "${mod}+egrave" = "workspace ${ws7}";
          "${mod}+underscore" = "workspace ${ws8}";
          "${mod}+w" = "workspace ${ws9}";
          "${mod}+x" = "workspace ${ws10}";
          "${mod}+Shift+ampersand" = "move container to workspace ${ws1}";
          "${mod}+Shift+greater" = "move container to workspace ${ws1}";
          "${mod}+Shift+eacute" = "move container to workspace ${ws2}";
          "${mod}+Shift+Control_L" = "move container to workspace ${ws2}";
          "${mod}+Shift+quotedbl" = "move container to workspace ${ws3}";
          "${mod}+Shift+apostrophe" = "move container to workspace ${ws4}";
          "${mod}+Shift+parenleft" = "move container to workspace ${ws5}";
          "${mod}+Shift+minus" = "move container to workspace ${ws6}";
          "${mod}+Shift+egrave" = "move container to workspace ${ws7}";
          "${mod}+Shift+underscore" = "move container to workspace ${ws8}";
          "${mod}+Shift+W" = "move container to workspace ${ws9}";
          "${mod}+Shift+X" = "move container to workspace ${ws10}";
		  "${mod}+Shift+Space" = "floating toggle";

          "${mod}+Shift+C" = "reload";
          "${mod}+Shift+R" = "restart";
          "${mod}+Shift+N" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
        };
		output = {"*" = {bg = "${localinfo.homeDir}/wallpaper.jpg fill";};};
	};
	
  };

  home.file = {
    ".config/wofi/" = {
      source = ./wofi;
      recursive = true;
    };
  };
}
