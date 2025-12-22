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
}
