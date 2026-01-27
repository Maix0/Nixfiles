{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar.css;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "power-profiles-daemon"
          "bluetooth"
          "network#wifi"
          "hyprland/workspaces"
        ];
        modules-center = ["hyprland/window"];
        modules-right = [
          "backlight/slider"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          numeric-first = true;
          format = "{icon}";
          format-icons = {
            "1" = "1:";
            "2" = "2:";
            "3" = "3:";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "";
            "9" = "";
          };
        };
        "network#wifi" = {
          interface = "wlp1s0";
          format-wifi = "{essid} ({signalStrength}%) ";
        };
        "hyprland/window" = {
          max-length = 30;
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
        "clock" = {
          locale = "en_GB.UTF-8";
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{:%W}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
          };
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
      }
    ];
  };
}
