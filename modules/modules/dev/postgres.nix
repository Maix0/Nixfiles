{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-postgres";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      ensureUsers = [];
    };
  };
}
