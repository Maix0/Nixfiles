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
    nixpkgs.config.problems.handlers = {
      libguestfs.broken = "warn"; # or "ignore"
    };
    boot.kernelModules = ["kvm-amd" "kvm-intel"];
    environment.systemPackages = with pkgs; [
      virt-manager
      vagrant
    ];
  };
}
