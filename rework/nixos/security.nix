{pkgs, ...}: {
  networking = {
    hostName = "XeLaptop";
    interfaces = {
      wlp1s0.useDHCP = true;
    };
    firewall.allowedTCPPorts = [8080 8085 5201 80 443];
  };
  services = {
    fprintd = {
      enable = true;
    };
  };
  security.pam.services.login.fprintAuth = true;
  systemd = {
    user.services = {
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
    pam.services.swaylock.text = ''
      auth include login
    '';
    pam.services.hyprlock.text = ''
      auth sufficient pam_fprintd.so
    '';
    pam.services.bitwarden.text = ''
      auth sufficient pam_fprintd.so
    '';
  };
  environment.systemPackages = [
    (pkgs.writeTextFile {
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
    })
  ];
}
