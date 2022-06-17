<<<<<<< HEAD
{ config, pkgs, ... }:

{
 /*
  boot.loader.grub.version 				 = 2;
  boot.loader.grub.enable                = true;
  boot.loader.grub.copyKernels           = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport            = true;
  boot.loader.grub.fsIdentifier          = "label";
  #boot.loader.grub.splashImage           = ./backgrounds/grub-nixos-3.png;
  boot.loader.grub.splashMode            = "stretch";

  boot.loader.grub.devices               = [ "nodev" ];
  boot.loader.grub.extraEntries = ''
    menuentry "Reboot" {
      reboot
    }
    menuentry "Poweroff" {
      halt
    }
  '';
 */
 boot.kernelParams = ["i8042.reset" "i8042.nomux" "i8042.nopnp" "i8042.noloop"];
 boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "ZeMaix";
    interfaces = {
      eno0.useDHCP = true;
      wlp1s0.useDHCP = true;
    };
  };
=======
{
  config,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/de0242ac-788a-44fc-a1ef-8d7bfaa448c6";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
        home = {
          device = "/dev/disk/by-uuid/b028c674-64c5-40e0-88c4-481d78854049";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
      };
      secrets = {
        "/etc/secrets/initrd/keyfile" = "/etc/secrets/initrd/keyfile";
      };
      #kernelParams = [ "iomem=relaxed" ];
    };
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        enableCryptodisk = true;
      };
    };
  };

  /*
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
   layout = "us";
   xkbVariant = "dvp";
   libinput.enable = true;
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
   		${pkgs.runtimeShell} $HOME/.hm-xsession-dbg&
   		waitPID=$!
   	'';
        }
      ];
    };
   */
>>>>>>> 9d7e1172ba612e06676d429483765214d144c40e

  users = {
    users = {
      maix = {
        uid = 1000;
        isNormalUser = true;
<<<<<<< HEAD
        home = "/home/maix";
        extraGroups = [ "wheel" "networkmanager" "adbusers" "audio" "docker" ];
        shell = pkgs.zsh;
      };
      localtimed = {
		group = "localtimed";
		isSystemUser = true;
      };
	};
    groups.localtimed = { };
	groups.docker = {};
=======
        home = "/home/traxys";
        extraGroups = ["wheel" "networkmanager" "adbusers"];
        shell = pkgs.zsh;
      };
      localtimed = {
        group = "localtimed";
        isSystemUser = true;
      };
    };
    groups.localtimed = {};
>>>>>>> 9d7e1172ba612e06676d429483765214d144c40e
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

<<<<<<< HEAD
=======
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip pkgs.gutenprint pkgs.cnijfilter2];
  };
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

>>>>>>> 9d7e1172ba612e06676d429483765214d144c40e
  hardware.opengl = {
    enable = true;
  };
}
