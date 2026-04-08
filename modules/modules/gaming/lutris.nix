{
  inputs,
  lib,
  ...
}: let
  moduleName = "lutris";
in {
  #flake.modules.nixos.${moduleName} = {pkgs, ...}: {};

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    programs.lutris = {
      enable = true;
      extraPackages = with pkgs; [mangohud winetricks gamescope gamemode umu-launcher];
      protonPackages = [pkgs.proton-ge-bin];
      defaultWinePackage = pkgs.proton-ge-bin;
      winePackages = [pkgs.wineWow64Packages.full];
    };
  };
}
