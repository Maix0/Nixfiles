{
  pkgs,
  config,
  myPkgs,
  ...
}: {
  environment.systemPackages = [
    config.boot.kernelPackages.perf
    myPkgs.zshMaix
    pkgs.acpi
    pkgs.bottom
    pkgs.fastmod
    pkgs.htop
    pkgs.podman
    pkgs.podman-compose
    pkgs.podman-tui
    pkgs.ripgrep
    pkgs.tree
    pkgs.virt-manager
  ];

  services = {
    privoxy.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };
  environment.extraInit = ''
    [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  '';

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  networking.networkmanager.enable = true;
  users.users."${config.extraInfo.username}".extraGroups = [
    "networkmanager"
    "wheel"
    "adbusers"
    "audio"
    "video"
    "podman"
    "docker"
    "dialout"
  ];
}
