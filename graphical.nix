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
    spotify

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

  # xdg.mime.defaultApplications = { "text/x-csharp" = "nvim-unity.desktop"; };
  xdg.desktopEntries = {
    nvim-unity = {
      name = "nvim-unity";
      exec = "/home/maix/bin/nvim-unity %f";
      terminal = true;
      mimeType = ["text/x-csharp"];
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  programs = {
    zathura = {
      enable = true;
    };
  };
}
