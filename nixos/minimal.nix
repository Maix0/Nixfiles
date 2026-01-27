{
  pkgs,
  lib,
  myPkgs,
  ...
}: {
  imports = [];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  virtualisation.containers.enable = lib.mkForce false;

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "69-probe-rs.rules";
      destination = "/etc/udev/rules.d/69-probe-rs.rules";
      text = builtins.readFile ./69-probe-rs.rules;
    })
  ];

  users.groups = {
    plugdev = {};
    localtimed = {};
    docker = {};
  };

  users.users.maix = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/maix";
    shell = myPkgs.zshMaix;
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "docker"
      "lp"
      "networkmanager"
      "plugdev"
      "podman"
      "scanner"
      "vboxusers"
      "video"
      "wheel"
      "libvirtd"
    ];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    nix-ld = {
      enable = true;
      libraries = [];
    };
    light.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    packages = [pkgs.terminus_font];
    font = "ter-v32n";
    keyMap = "us";
  };
  time.timeZone = "Europe/Paris";
  environment = {
    extraInit = ''
      [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    pathsToLink = ["/share/zsh"];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      hack-font
      dejavu_fonts
      noto-fonts-color-emoji
      noto-fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["DejaVu"];
        sansSerif = ["DejaVu Sans"];
        monospace = ["Hack Nerd Font Mono"];
      };
    };
  };

  security.polkit.enable = true;
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  #services.tlp.enable = true;
}
