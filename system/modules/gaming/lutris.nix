{
  inputs,
  lib,
  ...
}: let
  moduleName = "gaming-lutris";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    nixpkgs.overlays =
      lib.warn ''
        Remove openldap overlay when https://github.com/NixOS/nixpkgs/issues/514113 is closed
      '' [
        (_: prev: {
          openldap = prev.openldap.overrideAttrs {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          };
        })
      ];
    programs.lutris = {
      enable = true;
      extraPackages = with pkgs; [mangohud winetricks gamescope gamemode umu-launcher];
      protonPackages = [pkgs.proton-ge-bin];
      defaultWinePackage = pkgs.proton-ge-bin;
      winePackages = [pkgs.wineWow64Packages.full];
    };
  };
}
