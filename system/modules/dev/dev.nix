{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      dev-postgres
      dev-probe-rs
      dev-virt
      dev-virtualbox
    ];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      dev-tools
      dev-ghidra
      dev-man
      dev-probe-rs
      dev-nvim
      #dev-ida
    ];
  };
}
