{
  inputs,
  lib,
  ...
}: {
  # To add a user:
  # flake.modules = inputs.self.lib.mkUser "<name>" {}
  config.flake.lib.mkUser = name: fargs: let
    builder = {
      pkgs,
      lib,
      ...
    }: {
      admin ? false,
      uid ? null,
      shell ? null,
      extraGroups ? [],
    }: {
      imports =
        inputs.self.lib.optionalModule "hm-${name}" inputs.self.modules.nixos;
      users.users."${name}" = {
        isNormalUser = true;
        home = "/home/${name}";
        extraGroups =
          (lib.optionals admin [
            "wheel"
            "networkmanager"
          ])
          ++ extraGroups;
        shell =
          if shell != null
          then shell
          else pkgs.zsh;
        inherit uid;
      };
      programs.zsh.enable = lib.mkDefault shell == null;
    };
  in {
    nixos."user-${name}" = {
      lib,
      pkgs,
      system,
      ...
    } @ args:
      if builtins.isFunction fargs
      then builder args (fargs args)
      else builder args fargs;
  };
}
