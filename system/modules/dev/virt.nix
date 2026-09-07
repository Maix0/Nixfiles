{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-virt";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    virtualisation = {
      podman.enable = true;
      docker.enable = true;
      libvirtd.enable = true;
    };
    boot.kernelModules = ["kvm-amd" "kvm-intel"];
    environment.systemPackages = with pkgs; [
      virt-manager
      vagrant
    ];
  };
}
