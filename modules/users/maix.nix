{
  inputs,
  lib,
  ...
}: {
  flake.homeConfiguration = inputs.self.lib.mkHomeManager "x86_64-linux" "maix";
  flake.modules = lib.mkMerge [
    (inputs.self.lib.mkUser "maix" true)
    (inputs.self.lib.mkHome "maix")
    {
      nixos.maix = {
        programs.nh.flake = "/home/maix/Nixfiles";
      };
      homeManager.ethan = {
        config,
        pkgs,
        ...
      }: {
        imports = with inputs.self.modules.homeManager; [
          home-gui
          hyprland
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
