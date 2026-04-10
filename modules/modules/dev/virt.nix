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

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm; # only emulates host arch, smaller download
          swtpm.enable = true; # allows for creating emulated TPM
        };
      };
    };
    environment.systemPackages = with pkgs; [
      virt-manager
      vagrant
    ];
  };
}
