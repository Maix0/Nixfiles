{extraInfo}: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [extraInfo ./cachix.nix];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  virtualisation.containers.enable = lib.mkForce false;

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    home = "/home/${config.extraInfo.username}";
    shell = pkgs.zshMaix;
    extraGroups = ["wheel" "video"];
  };
  nixpkgs.config.permittedInsecurePackages = [
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
    ];

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

  nixpkgs.overlays = [
    (final: super: {
      nixos-rebuild = super.nixos-rebuild.overrideAttrs (old: {
        src = "${final.runCommand "nixos-rebuild.sh" {} ''
          mkdir -p $out

          cp ${old.src} nixos-rebuild.sh

          patch -p5 <${./nom-rebuild.patch}
          sed -i -e '2s|^|export PATH="${lib.makeBinPath [final.nix-output-monitor]}:$PATH"|' nixos-rebuild.sh
          mv nixos-rebuild.sh $out
        ''}/nixos-rebuild.sh";
      });
    })
  ];

  nix = {
    package = pkgs.nixVersions.git;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
      trusted-users = ["@wheel" config.extraInfo.username];
    };
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  security.polkit.enable = true;
}
