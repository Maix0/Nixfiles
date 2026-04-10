{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-waydroid";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };

    environment.systemPackages = [
      pkgs.waydroid-helper
      pkgs.wl-clipboard
    ];

    systemd = {
      packages = [pkgs.waydroid-helper];
      services.waydroid-mount.wantedBy = ["multi-user.target"];
    };
  };
}
