{
  pkgs,
  config,
  ...
}: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = [
    pkgs.itd
    pkgs.rofi
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd sway";
        user = "greeter";
      };
    };
  };

  #hardware.tuxedo-control-center.enable = true;

  systemd.user.services.itd = {
    enable = false;
    description = "InfiniTime Daemon (itd)";
    after = ["bluetooth.target"];
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${pkgs.itd}/bin/itd";
      Restart = "always";
      #StandartOutput = "journal";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.noisetorch.enable = true;

  programs.adb.enable = true;
  programs.dconf.enable = true;

  virtualisation.waydroid.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.bluetooth.enable = true;

  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };
  services.udev.packages = [pkgs.yubikey-personalization];

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip pkgs.gutenprint pkgs.cnijfilter2];
  };
  hardware.sane.enable = true;
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  users.users."${config.extraInfo.username}".extraGroups = ["adbusers" "scanner" "lp"];
}
