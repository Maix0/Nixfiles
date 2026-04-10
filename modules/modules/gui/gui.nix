{
  inputs,
  lib,
  ...
}: let
  moduleName = "gui";
in {
  flake.modules.nixos.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      gui-bitwarden
      gui-fonts
      gui-foot
      gui-hyprland
      gui-polkit
      gui-waydroid
    ];

    xdg.portal = {
      config.common.default = "hyprland;gtk";
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    environment.systemPackages = with pkgs; [
      rofi
      polkit_gnome
      polkit
      inputs.rose-pine-hyprcursor.packages.${system}.default
      android-tools
    ];

    programs = {
      noisetorch.enable = true;
      dconf.enable = true;
    };
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      gnome.gnome-keyring.enable = true;
      flatpak.enable = true;
      avahi = {
        nssmdns4 = true;
        enable = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
          gutenprint
          gutenprintBin
        ];
      };
    };
  };

  flake.modules.homeManager.${moduleName} = {
    pkgs,
    system,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      gui-bitwarden
      gui-browser
      gui-foot
      gui-hyprland
    ];

    gtk = {
      enable = true;
      font.name = "DejaVu Sans";
      
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

      # Misc
      eog
      fzf
      krita
      inputs.aseprite.packages.${system}.default
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
