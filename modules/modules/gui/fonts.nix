{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-fonts";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.hack
        hack-font
        dejavu_fonts
        noto-fonts-color-emoji
        noto-fonts
      ];
      fontconfig = {
        defaultFonts = {
          serif = ["DejaVu"];
          sansSerif = ["DejaVu Sans"];
          monospace = ["Hack Nerd Font Mono"];
        };
      };
    };
  };
}
