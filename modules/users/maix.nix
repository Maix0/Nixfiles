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
      shell = inputs.zsh.packages.${system}.zsh;
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
      nixos.user-maix = {
        programs.nh.flake = "/home/maix/Nixfiles";
      };
      homeManager.hm-maix = {
        config,
        pkgs,
        ...
      }: {
        imports = with inputs.self.modules.homeManager; [
          minimal
          gaming
          dev
          gui
          cli
        ];
        home.packages = with pkgs; [];
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
