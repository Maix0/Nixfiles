{
  inputs,
  lib,
  ...
}: {
  # To add a home
  # flake.modules = inputs.self.lib.mkHome "<name>"
  config.flake.lib.mkHome = username: {
    nixos."user-${username}" = {
      imports = [inputs.home-manager.nixosModules.home-manager];
      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."hm-${username}"
          inputs.self.modules.homeManager.lib-system
        ];
      };
      home-manager.backupFileExtension = "backup";
    };
    homeManager."hm-${username}" = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
    };
  };
}
