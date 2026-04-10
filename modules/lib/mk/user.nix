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
        lib.optionals
        (builtins.hasAttr "hm-${name}" inputs.self.modules.nixos)
        [inputs.self.modules.nixos."hm-${name}"];
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
          if !(builtins.isNull shell)
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
