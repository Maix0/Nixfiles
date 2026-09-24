{
  inputs,
  lib,
  ...
}: let
  moduleName = "dev-wifi";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    assertions = [
      {
        assertion = builtins.hasAttr "unifi-desktop-nix" inputs;
        message = "unifi-desktop-nix input needed to include module `${moduleName}`";
      }
    ];
    imports = [
      inputs.unifi-desktop-nix.nixosModules.wifiman-desktop
    ];
    services.wifiman-desktop.enable = true;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) ["wifiman-desktop"];
  };
}
