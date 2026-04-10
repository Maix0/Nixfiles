{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui-bitwarden";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    security.pam.services.bitwarden.text = ''
      auth sufficient pam_fprintd.so
    '';

    environment.systemPackages = [
      (pkgs.stdenvNoCC.mkDerivation {
        name = "bitwarden-polkit";
        src = pkgs.bitwarden-desktop;
        dontUnpack = true;
        installPhase = ''
          mkdir -pv $out/share/polkit-1/
          cp -rv $src/share/polkit-1/actions/ $out/share/polkit-1/
        '';
      })
    ];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
    home.packages = with pkgs; [bitwarden-desktop bitwarden-cli];
  };
}
