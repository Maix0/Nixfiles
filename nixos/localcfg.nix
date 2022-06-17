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

  users = {
    users = {
      maix = {
        uid = 1000;
        isNormalUser = true;
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
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  hardware.opengl = {
    enable = true;
  };
}
