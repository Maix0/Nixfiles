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
      ];
    }))
    (inputs.self.lib.mkHome "maix")
    {
      nixos.user-maix = {system, ...}: {
        programs.nh.flake = "/home/maix/Nixfiles";
        users.users.maix.ignoreShellProgramCheck = true;
        users.users.maix.shell = lib.mkForce inputs.self.packages.${system}.zsh;
        environment.shells = [
          "${inputs.self.packages.${system}.zsh}/bin/zsh"
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
        home.packages = with pkgs; [
          inputs.self.packages.${system}.zsh
        ];
        programs.git.settings = {
          user = {
            name = "Maix0";
            email = "39835848+Maix0@users.noreply.github.com";
            signingkey = "/home/maix/.ssh/id_ed25519.pub";
          };
        };
        home.stateVersion = "23.11";
        programs.home-manager.enable = true;
      };
    }
  ];
}
