{
  pkgs,
  myPkgs,
  ...
}: {
  xdg = {
    portal = {
      config.common.default = "*";
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    polkit_gnome
    polkit

    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    myPkgs.rose-pine-hyprcursor
  ];

  programs = {
    noisetorch.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };
}
