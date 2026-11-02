{
  inputs,
  lib,
  ...
}: let
  moduleName = "min-nix";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      distributedBuilds = true;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        builders-use-substitutes = true;
        auto-optimise-store = true;
        keep-outputs = true;
        keep-derivations = true;

        trusted-users = ["@wheel" "maix"];
      };
    };
  };
}
