{ config, pkgs, lib, ... }:

{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # boot.extraModulePackages = [ ashmem binder ];
  # boot.kernelModules = [ "ashmem_linux" "binder_linux" ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  /* nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
    nativeOnly = true;
    };
    }; */

  programs.steam.enable = true;
}
