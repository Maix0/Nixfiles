# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./pkg.nix
      #./home.nix
      ./localcfg.nix
    ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    localtime.enable = true;
    fwupd.enable = true;
    postgresql = {
      enable = true;
    };
  };
  programs.adb.enable = true;
  programs.dconf.enable = true;
	
  hardware.opengl.extraPackages = with pkgs; [
   	rocm-opencl-icd
   	rocm-opencl-runtime
  	amdvlk
  ];

  hardware.opengl.enable = true;

  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  
	
  fonts.enableDefaultFonts = true;
  fonts = {
    fonts = with pkgs; [
	  liberation_ttf
      (nerdfonts.override { fonts = [ "Hack" ]; })
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Hack" ];
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages;
  /* nixpkgs.config.allowBroken = true; */
  virtualisation.docker.enable = true;

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  


  networking.networkmanager.enable = true;
  programs.noisetorch.enable = true;

  networking.firewall.allowedTCPPorts = [
    8080
  ];

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d"; # Ajuste comme tu veux, tu peux utiliser +5 pour garder les 5 dernières, etc.
  };
	
  sound.enable = true;	
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
