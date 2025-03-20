{
  pkgs,
  config,
  myPkgs,
  ...
}: {
  xdg = {
    portal = {
      config.common.default = [
        "gtk"
        "wlr"
      ];
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = let
    polkit-bitwarden = pkgs.writeTextFile {
      name = "com.bitwarden.Bitwarden.policy";
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE policyconfig PUBLIC
         "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
         "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">

        <policyconfig>
            <action id="com.bitwarden.Bitwarden.unlock">
              <description>Unlock Bitwarden</description>
              <message>Authenticate to unlock Bitwarden</message>
              <defaults>
                <allow_any>no</allow_any>
                <allow_inactive>no</allow_inactive>
                <allow_active>auth_self</allow_active>
              </defaults>
            </action>
        </policyconfig>
      '';
      destination = "/share/polkit-1/actions/com.bitwarden.Bitwarden.policy";
    };
  in [
    polkit-bitwarden
    pkgs.itd
    pkgs.rofi
    pkgs.polkit_gnome
    pkgs.polkit

    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-gnome
    myPkgs.rose-pine-hyprcursor
  ];

  systemd = {
    user.services = {
      itd = {
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
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
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
    pam.services.bitwarden.text = ''
      auth sufficient pam_fprintd.so
    '';
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd Hyprland";
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
    #opentabletdriver.enable = true;
    bluetooth.enable = true;
  };
  users.users."${config.extraInfo.username}".extraGroups = ["adbusers" "scanner" "lp" "vboxusers"];
  # virtualisation.virtualbox.host.enable = true;
}
