{
  inputs,
  lib,
  ...
}: {
  # perSystem = {
  #   pkgs,
  #   self',
  #   inputs',
  #   ...
  # }: let
  #   packageName = "hello";
  # in {
  #   packages.${packageName} = pkgs.hello;
  #
  #   apps.${packageName} = {
  #     meta.description = "${packageName}";
  #     program = self'.packages.${packageName};
  #     type = "app";
  #   };
  # };
}
