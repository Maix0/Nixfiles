{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./wm
  ];

  home.packages = with pkgs; [
    # Browsers
    firefox-wayland
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    # IM
    (discord.override {nss = pkgs.nss;})
    element-desktop
    signal-desktop

    # Mail
    thunderbird-wayland

    # Media
    gromit-mpx
    krita
    pavucontrol
    qpwgraph
 	  #spotify
    vlc

    # Libreoffice
    hunspell
    hunspellDicts.fr-any
    hyphen
    libreoffice

    # Misc
    gnome.eog
    freecad
    plasma5Packages.kdeconnect-kde
    wdisplays
    wl-clipboard
    wl-mirror
    xdg-utils
    fzf
    aseprite-flake
    quickemu
    virt-viewer
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    GTK_USE_PORTAL = 1;
    NIXOS_OZONE_WL = 1;
  };

  programs.zathura.enable = true;

  programs.spicetify = {
    enable = true;
    theme = pkgs.spicetify.themes.Fluent;
    colorScheme = "dark";

    enabledCustomApps = with pkgs.spicetify.apps; [
      new-releases
      marketplace
      lyrics-plus
    ];

    enabledExtensions = with pkgs.spicetify.extensions; [
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      bookmark
      groupSession
      playlistIcons
      goToSong
      featureShuffle
      songStats
      showQueueDuration
      copyToClipboard
      history
      playNext
    ];
  };
}
