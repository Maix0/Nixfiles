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
    packageName = "sieve-editor-gui";
  in {
    packages.${packageName} = pkgs.sieve-editor-gui.override {
      buildNpmPackage = pkgs.buildNpmPackage.override {nodejs = pkgs.nodejs_22;};
    };

    apps.${packageName} = {
      meta.description = "${packageName}";
      program = self'.packages.${packageName};
      type = "app";
    };
  };
}
