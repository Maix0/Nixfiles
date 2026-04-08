{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.gui = {pkgs, ...}: {
    xdg = {
      portal = {
        config.common = {
          default = "hyprland;gtk";
        };
        #xdgOpenUsePortal = true;
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      rofi
      polkit_gnome
      polkit
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      android-tools
    ];

    programs = {
      noisetorch.enable = true;
      dconf.enable = true;
    };
  };

  flake.modules.homeManager.gui = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [browser hyprland];

    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans";
      };
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };
    home.packages = with pkgs; [
      # IM
      vesktop
      signal-desktop

      # Mail
      thunderbird

      # Media
      pavucontrol
      qpwgraph
      spotify
      vlc

      # Libreoffice
      hunspell
      hunspellDicts.fr-any
      hyphen
      libreoffice

      # Misc
      eog
      fzf
      ghidra-bin
      krita
      myPkgs.aseprite
      mypaint
      virt-viewer
      waypipe
      wdisplays
      wl-clipboard
      wl-mirror
      xdg-utils
    ];
  };
}
