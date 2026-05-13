{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    inputs',
    ...
  }: let
    mkKicad = version: versionFile:
      pkgs.callPackage ./_files/kicad_package.nix {
        majorVersion = version;
        versionsImportFile = versionFile;
      };
  in {
    packages.kicad = pkgs.kicad;
    apps.kicad = {
      meta.description = "kicad";
      program = self'.packages.kicad;
      type = "app";
    };
    packages.kicad_10 = mkKicad "10" ./_files/version10.nix;
    apps.kicad_10 = {
      meta.description = "kicad_10";
      program = self'.packages.kicad_10;
      type = "app";
    };
    packages.kicad_9 = mkKicad "9" ./_files/version9.nix;
    apps.kicad_9 = {
      meta.description = "kicad_9";
      program = self'.packages.kicad_9;
      type = "app";
    };
  };
}
