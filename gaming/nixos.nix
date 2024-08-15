{pkgs, lib,  ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  hardware.steam-hardware.enable = true;

  boot.kernelPackages = lib.trivial.warn "Update Kernel version when tuxedo-driver is fixed" pkgs.linuxKernel.packages.linux_xanmod;

  security.wrappers = {
    gamescope = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamescope}/bin/gamescope";
      capabilities = "cap_sys_nice+ep";
    };
  };
}
