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
    myPkgs.zen-browser

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
