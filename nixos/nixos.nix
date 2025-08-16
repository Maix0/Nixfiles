{
  pkgs,
  config,
  myPkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    acpi
    bottom
    config.boot.kernelPackages.perf
    fastmod
    htop
    myPkgs.zshMaix
    patchelf
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
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  networking.networkmanager.enable = true;
  nix = {
    buildMachines = let
      loServer = {
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
      };
    in [
      #loServer
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
