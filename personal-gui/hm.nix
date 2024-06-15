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
    ghidra-bin

    # Browsers
    firefox
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    # IM
    vesktop
    element-desktop
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
    waypipe
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    GTK_USE_PORTAL = 1;
    NIXOS_OZONE_WL = 1;
    ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
  };

  programs.zathura.enable = true;

  # programs.spicetify = {
  #   enable = true;
  #   theme = "Dreary"; #pkgs.spicetify.themes.Dreary;
  #   colorScheme = "deeper";
  #
  #   enabledCustomApps = with pkgs.spicetify.apps; [
  #     new-releases
  #     marketplace
  #     lyrics-plus
  #     localFiles
  #   ];
  #
  #   enabledExtensions = with pkgs.spicetify.extensions; [
  #     shuffle # shuffle+ (special characters are sanitized out of ext names)
  #     bookmark
  #     groupSession
  #     playlistIcons
  #     goToSong
  #     featureShuffle
  #     songStats
  #     showQueueDuration
  #     copyToClipboard
  #     history
  #     playNext
  #   ];
  # };
  #
  # xdg.desktopEntries = {
  #   spotify = {
  #     name = "Spiced Spotify";
  #     exec = "spotify";
  #     icon = "spotify";
  #     type = "Application";
  #   };
  # };
}
