{
  inputs,
  lib,
  ...
}: let
  packageName = "template";
in {
  flake.packages.${packageName} = {};
}
