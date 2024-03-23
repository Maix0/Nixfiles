{extraInfo}: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [extraInfo];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  virtualisation.containers.enable = lib.mkForce false;

  programs.nix-ld.enable = true;

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    home = "/home/${config.extraInfo.username}";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "video"];
  };

  programs.zsh.enable = true;
  programs.light.enable = true;
  networking.hosts = {
    "www.bottlecaps.de" = ["127.0.0.1"];
  };
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  environment.pathsToLink = ["/share/zsh"];
  fonts = {
    fonts = with pkgs; [
      # otf
      (nerdfonts.override {fonts = ["Hack"];})
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

  nixpkgs.overlays = [
    (final: super: {
      nixos-rebuild = super.nixos-rebuild.overrideAttrs (old: {
        path = "${old.path}:${lib.makeBinPath [final.nix-output-monitor]}";
        src = lib.debug.traceVal "${final.runCommand "nixos-rebuild.sh" {} ''
          mkdir -p $out

          cp ${old.src} nixos-rebuild.sh

          patch -p5 <${./nom-rebuild.patch}
          mv nixos-rebuild.sh $out
        ''}/nixos-rebuild.sh";
      });
    })
  ];

  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  security.polkit.enable = true;
}
