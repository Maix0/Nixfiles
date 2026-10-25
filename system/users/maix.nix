{
  inputs,
  lib,
  ...
}: {
  flake.homeConfiguration = inputs.self.lib.mkHomeManager "x86_64-linux" "maix";
  flake.modules = lib.mkMerge [
    (inputs.self.lib.mkUser "maix" ({system, ...}: {
      admin = true;
      uid = 1000;
      shell = null;
      extraGroups = [
        "adbusers"
        "audio"
        "dialout"
        "docker"
        "lp"
        "plugdev"
        "podman"
        "scanner"
        "vboxusers"
        "video"
        "libvirtd"
        "qemu-libvirtd"
      ];
    }))
    (inputs.self.lib.mkHome "maix")
    {
      nixos.user-maix = {system, ...}: {
        programs.nh.flake = "/home/maix/Nixfiles";
        users.users.maix.ignoreShellProgramCheck = true;
        users.users.maix.shell = lib.mkForce inputs.self.packages.${system}.zsh;
        environment.shells = [
          (lib.getExe inputs.self.packages.${system}.zsh)
        ];
      };
      homeManager.hm-maix = {
        config,
        pkgs,
        system,
        ...
      }: {
        imports = with inputs.self.modules.homeManager; [
          minimal
          gaming
          dev
          gui
          cli
        ];
        home.packages = [
          inputs.self.packages.${system}.zsh
        ];
        programs = {
          fastfetch.enable = true;
          home-manager.enable = true;
          git.settings = {
            user = {
              name = "Maix0";
              email = "39835848+Maix0@users.noreply.github.com";
              signingkey = "/home/maix/.ssh/id_ed25519.pub";
            };
          };
          vdirsyncer.enable = true;
        };
        home.stateVersion = "23.11";

        services.vdirsyncer.enable = true;

        accounts.calendar = let
          printCmd = pkgs.writeShellScript "getEnv" ''
            set -ue
            file=$(eval echo "$1")
            source "$file"
            echo "${"$"}{!2}"
          '';
          secretName = "maix-calendar";
          hasSecret = builtins.hasAttr secretName config.age.secrets;
          s =
            if hasSecret
            then config.age.secrets.${secretName}
            else {};
        in {
          basePath = ".calendar";
          accounts.personal = {
            noctalia.enable = true;
            primary = true;
            primaryCollection = "QC";
            remote = lib.mkIf hasSecret {
              type = "caldav";
              url = "https://nextcloud.familleboyer.net/remote.php";
              passwordCommand = [
                "${printCmd}"
                "${s.path}"
                "CAL_PASS"
              ];
            };
            vdirsyncer = lib.mkIf hasSecret {
              enable = true;
              collections = ["from a"];
              userNameCommand = [
                "${printCmd}"
                "${s.path}"
                "CAL_USER"
              ];
              metadata = [
                "color"
                "displayname"
              ];
            };
          };
        };
      };
    }
  ];
}
