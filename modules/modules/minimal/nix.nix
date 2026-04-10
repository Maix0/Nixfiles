{
  inputs,
  lib,
  ...
}: let
  moduleName = "min-nix";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    nix = {
      buildMachines = let
        loServer = {
          system = "x86_64-linux";
          supportedFeatures = [
            "benchmark"
            "big-parallel"
            "kvm"
            "nixos-test"
          ];
          sshUser = "root";
          sshKey = "/root/.ssh/id_buildremotekey";
          maxJobs = 8;
          hostName = "maix.me";
        };
      in [
        #loServer
      ];
      distributedBuilds = true;
      settings = {
        experimental-features = "nix-command flakes";
        builders-use-substitutes = true;
        auto-optimise-store = true;
        keep-outputs = true;
        keep-derivations = true;

        trusted-users = ["@wheel" "maix"];
      };
    };
  };
}
