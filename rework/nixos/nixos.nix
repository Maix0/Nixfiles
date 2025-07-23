{
  pkgs,
  config,
  myPkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.perf
    myPkgs.zshMaix
    acpi
    bottom
    fastmod
    htop
    podman
    podman-compose
    podman-tui
    ripgrep
    tree
    virt-manager
  ];

  services = {
    privoxy.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    tzupdate.enable = true;
    localtimed.enable = true;
    geoclue2.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  networking.networkmanager.enable = true;
  nix = {
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

      trusted-users = ["@wheel" "maix"];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
