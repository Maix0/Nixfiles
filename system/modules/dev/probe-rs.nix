{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-probe-rs";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "69-probe-rs.rules";
        destination = "/etc/udev/rules.d/69-probe-rs.rules";
        text = builtins.readFile ./files/69-probe-rs.rules;
      })
    ];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {};
}
