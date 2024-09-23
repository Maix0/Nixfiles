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
    pkgs.polkit_gnome
    pkgs.polkit
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
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "com.bitwarden.Bitwarden.unlock") {
          // Allow only the currently active user to authenticate
          if (subject.active) {
            return polkit.Result.AUTH_SELF; // Require the user's own authentication
          }
          // Deny for inactive or other users
          return polkit.Result.NO;
        }
      });
    '';
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
