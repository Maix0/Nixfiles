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
}
