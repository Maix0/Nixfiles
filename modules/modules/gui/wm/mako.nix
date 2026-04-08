{
  inputs,
  lib,
  ...
}: let
  moduleName = "mako";
in {
  #flake.modules.nixos.${moduleName} = {pkgs, ...}: {};

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = builtins.toString 7000;
        font = "hack nerd font 10";
        margin = "20,20,5,5";
        output = "eDP-1";
      };
    };
  };
}
