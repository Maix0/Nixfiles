{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    inputs',
    ...
  }: let
    packageName = "hyprpowerctl";
  in {
    packages.${packageName} = let
      mkOption = icon: name: {inherit icon name;};
      options = {
        shutdown = mkOption "⏻" "Shutdown";
        restart = mkOption "" "Restart";
        logout = mkOption "󰗽" "Logout";
        sleep = mkOption "󰤄" "Sleep";
        lock = mkOption "" "Lock";
      };
      mkChoice = {
        icon,
        name,
      }: " ${icon}  ${name}";
    in
      pkgs.writeShellApplication {
        name = "hyprpowerctl";
        # ⏻ Shutdown
        #  Restart
        # 󰗽 Logout
        # 󰤄 Sleep
        #  Lock

        text = ''
          RESULT="$(printf "${mkChoice options.shutdown}\n${mkChoice options.restart}\n${mkChoice options.logout}\n${mkChoice options.sleep}\n${mkChoice options.lock}" | ${lib.getExe pkgs.hyprlauncher} --dmenu)";

          case "$RESULT" in
            "${mkChoice options.shutdown}")
              ${lib.getExe pkgs.hyprshutdown} -t "Confirm shutdown..." -p "shutdown -P 0";
              ;;
            "${mkChoice options.restart}")
              ${lib.getExe pkgs.hyprshutdown} -t "Confirm reboot..." -p "reboot";
              ;;
            "${mkChoice options.logout}")
              ${lib.getExe pkgs.hyprshutdown} -t "Confirm logout...";
              ;;
            "${mkChoice options.sleep}")
              ${lib.getExe' pkgs.systemd "systemctl"} suspend;
              ;;
            "${mkChoice options.lock}")
              ${lib.getExe pkgs.hyprlock};
              ;;
          esac
        '';
      };

    apps.${packageName} = {
      meta.description = "${packageName}";
      program = self'.packages.${packageName};
      type = "app";
    };
  };
}
