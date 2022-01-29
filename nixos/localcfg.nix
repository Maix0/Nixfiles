{ config, pkgs, ... }:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/disk/by-uuid/E50B-9F01";
      };
    };
  };

  networking = {
    hostName = "ZeMaix";
    interfaces = {
      eno0.useDHCP = true;
      wlp1s0.useDHCP = true;
    };
  };

  users = {
    users = {
      maix = {
        uid = 1000;
        isNormalUser = true;
        home = "/home/maix";
        extraGroups = [ "wheel" "networkmanager" "adbusers" "audio" ];
        shell = pkgs.zsh;
      };
      localtimed.group = "localtimed";
    };
    groups.localtimed = { };
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  hardware.opengl = {
    enable = true;
  };
}
