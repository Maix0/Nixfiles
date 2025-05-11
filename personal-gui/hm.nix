{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}: {
  imports = [
    ./wm
  ];

  home.packages = with pkgs; [
    # Browsers
    firefox
    myPkgs.zen-browser

    # IM
    vesktop
    signal-desktop-bin

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

    bitwarden-desktop

    # Misc
    eog
    fzf
    ghidra-bin
    krita
    myPkgs.aseprite
    mypaint
    plasma5Packages.kdeconnect-kde
    virt-viewer
    virtualbox
    waypipe
    wdisplays
    wl-clipboard
    wl-mirror
    xdg-utils
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
    BROWSER = "zen";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = 1;
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  programs.zathura.enable = true;
}
