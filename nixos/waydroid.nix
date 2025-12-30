{pkgs, ...}: {
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.systemPackages = [
    pkgs.waydroid-helper
    pkgs.wl-clipboard
  ];

  systemd = {
    packages = [pkgs.waydroid-helper];
    services.waydroid-mount.wantedBy = ["multi-user.target"];
  };
}
