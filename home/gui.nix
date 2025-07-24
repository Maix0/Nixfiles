{
  pkgs,
  myPkgs,
  ...
}: {
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
    # Browsers
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
}
