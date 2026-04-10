{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-virtualbox";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    config = {
      virtualisation.virtualbox.host.enable = true;
      boot.kernelParams = ["kvm.enable_virt_at_load=0"];
    };
  };
}
