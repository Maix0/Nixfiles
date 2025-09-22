{
  pkgs,
  myPkgs,
  ...
}: {
  xdg = {
    portal = {
      config.common = {
        default = "hyprland;gtk";
      };
      #xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    polkit_gnome
    polkit
    myPkgs.rose-pine-hyprcursor
  ];

  programs = {
    noisetorch.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };
}
