{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    config.boot.kernelPackages.perf
    pkgs.virt-manager
  ];

  services.privoxy.enable = true;

  services.fwupd.enable = true;
  services.openssh.enable = true;
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
