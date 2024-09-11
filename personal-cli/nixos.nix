{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    config.boot.kernelPackages.perf
    pkgs.virt-manager
    pkgs.zshMaix
  ];

  services = {
    privoxy.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  networking.networkmanager.enable = true;
  users.users."${config.extraInfo.username}".extraGroups = [
    "networkmanager"
    "wheel"
    "adbusers"
    "audio"
    "video"
  ];
}
