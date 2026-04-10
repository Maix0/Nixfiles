{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-tools";
in {
  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    home.packages = with pkgs; [
      bottom
      fastmod
      fd
      file
      gef
      gnumake
      htop
      jq
      ltrace
      nix-output-monitor
      oscclip
      ripgrep
      rsync
      socat
      tokei
      tree
      unzip
      wget
      strace
    ];
  };
}
