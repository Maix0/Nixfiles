{extraInfo}: {
  config,
  pkgs,
  lib,
  myPkgs,
  ...
}: {
  imports = [extraInfo ./cachix.nix];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  virtualisation.containers.enable = lib.mkForce false;

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    home = "/home/${config.extraInfo.username}";
    shell = myPkgs.zshMaix;
    extraGroups = ["wheel" "video"];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    nix-ld.enable = true;
    nix-ld.libraries = [];
    light.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    packages = [pkgs.terminus_font];
    font = "ter-v32n";
    keyMap = "us";
  };
  time.timeZone = "Europe/Paris";

  environment.pathsToLink = ["/share/zsh"];
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      hack-font
      dejavu_fonts
      noto-fonts-emoji
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

  nix = {
    package = pkgs.nixVersions.git;
    buildMachines = [
      {
        system = "x86_64-linux";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        sshUser = "root";
        sshKey = "/root/.ssh/id_buildremotekey";
        maxJobs = 8;
        hostName = "maix.me";
      }
    ];
    distributedBuilds = true;
    settings = {
      experimental-features = "nix-command flakes";
      builders-use-substitutes = true;
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;

      trusted-users = ["@wheel" config.extraInfo.username];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  security.polkit.enable = true;
}
