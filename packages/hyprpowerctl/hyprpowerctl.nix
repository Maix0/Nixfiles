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
      mkOption = icon: name: action: {inherit icon name action;};
      options = [
        (mkOption "" "Lock" "${lib.getExe pkgs.hyprlock}")
        (mkOption "󰗽" "Logout" "${lib.getExe pkgs.hyprshutdown} -t \"Confirm logout...\"")
        (mkOption "󰤄" "Sleep" "${lib.getExe' pkgs.systemd "systemctl"} suspend")
        (mkOption "⏻" "Shutdown" "${lib.getExe pkgs.hyprshutdown} -t \"Confirm shutdown...\" -p \"shutdown -P 0\"")
        (mkOption "" "Restart" "${lib.getExe pkgs.hyprshutdown} -t \"Confirm reboot...\" -p \"reboot\"")
      ];
      mkChoice = {
        icon,
        name,
        action,
      }: " ${icon}  ${name}";
      mkAction = {
        icon,
        name,
        action,
      } @ opts: ''
        "${mkChoice opts}")
          ${action};
          ;;
      '';
    in
      pkgs.writeShellApplication {
        name = "hyprpowerctl";
        # ⏻ Shutdown
        #  Restart
        # 󰗽 Logout
        # 󰤄 Sleep
        #  Lock

        text = ''
          RESULT="$(printf "${builtins.concatStringsSep "\\n" (builtins.map mkChoice options)}" | ${lib.getExe pkgs.hyprlauncher} --dmenu)";

          case "$RESULT" in
            ${builtins.concatStringsSep "\n" (map mkAction options)}
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
