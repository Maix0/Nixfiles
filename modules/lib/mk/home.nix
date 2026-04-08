{
  inputs,
  lib,
  ...
}: {
  # To add a home
  # flake.modules = inputs.self.lib.mkHome "<name>"
  config.flake.lib.mkHome = username: {
    nixos."${username}" = {
      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };
      home-manager.backupFileExtension = "backup";
    };
    homeManager."${username}" = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
    };
  };
}
