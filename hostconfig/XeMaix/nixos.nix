{
  boot.initrd = {
    enable = true;
    availableKernelModules = ["amdgpu" "r8169"];
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelParams = ["i8042.reset" "i8042.nomux" "i8042.nopnp" "i8042.noloop"];

  networking = {
    hostName = "XeMaix";
    interfaces = {
      en0.useDHCP = false;
      wlp1s0.useDHCP = true;
    };
  };

  users = {
    users.maix.uid = 1000;
    groups.localtimed = {};
    groups.docker = {};
  };
  hardware.bluetooth.enable = true;

  hardware.ckb-next.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
