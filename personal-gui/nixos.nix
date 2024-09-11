{
  pkgs,
  config,
  ...
}: {
  xdg = {
    portal = {
      config.common.default = "*";
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

  security = {
    rtkit.enable = true;
    pam.yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
    };
    pam.services.swaylock.text = ''
      auth include login
    '';
    pam.services.hyprlock = {};
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd sway";
          user = "greeter";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
    printing = {
      enable = true;
      drivers = [pkgs.hplip pkgs.gutenprint pkgs.cnijfilter2];
    };
    avahi = {
      nssmdns4 = true;
      enable = true;
    };
  };

  virtualisation.waydroid.enable = true;

  programs = {
    noisetorch.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };

  hardware = {
    sane.enable = true;
    graphics .enable = true;
    opentabletdriver.enable = true;
    bluetooth.enable = true;
  };
  users.users."${config.extraInfo.username}".extraGroups = ["adbusers" "scanner" "lp"];
}
