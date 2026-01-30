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
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    polkit_gnome
    polkit
    myPkgs.rose-pine-hyprcursor
    android-tools
  ];

  programs = {
    noisetorch.enable = true;
    dconf.enable = true;
  };
}
