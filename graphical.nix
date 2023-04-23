{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden
    firefox-wayland
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })
    # IM
    element-desktop
    (discord.override {nss = pkgs.nss;})
    signal-desktop

    # Mail
    thunderbird-wayland

    # Media
    pavucontrol
    vlc
    krita
    gromit-mpx

    # Libreoffice
    libreoffice
    hunspell
    hunspellDicts.fr-any
    hyphen

    # Misc progs
    bitwarden
    libreoffice-fresh
    feh
    alacritty
    # (tor-browser-bundle-bin.override {
    #  useHardenedMalloc = false;
    # })

    # Misc utils
    wl-clipboard
    xdg-utils
    feh
  ];

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

  /*
    environment.pathsToLink = [ "/share/hunspell" "/share/myspell" "/share/hyphen" ];
   environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
   */

  home.sessionVariables = {
    BROWSER = "firefox";
    GTK_USE_PORTAL = 1;
  };

  programs = {
    zathura = {
      enable = true;
    };
  };
}
