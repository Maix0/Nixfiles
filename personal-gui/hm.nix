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
    ghidra-bin

    # Browsers
    firefox

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

    bitwarden-desktop

    # Misc
    eog
    fzf
    myPkgs.aseprite
    myPkgs.zen-browser
    mypaint
    plasma5Packages.kdeconnect-kde
    virt-viewer
    waypipe
    wdisplays
    wl-clipboard
    wl-mirror
    xdg-utils
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
