{
  inputs,
  lib,
  ...
}: {
  # To add a user:
  # flake.modules = inputs.self.lib.mkUser "<name>" false
  config.flake.lib.mkUser = username: isAdmin: {
    nixos."${username}" = {
      lib,
      pkgs,
      ...
    }: {
      users.users."${username}" = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = lib.optionals isAdmin [
          "wheel"
          "networkmanager"
        ];
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;
    };
  };
}
