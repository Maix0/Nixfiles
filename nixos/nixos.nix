{
  pkgs,
  config,
  myPkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    acpi
    bottom
    fastmod
    htop
    myPkgs.zshMaix
    patchelf
    perf
    ripgrep
    tree
    virt-manager
    vagrant

    piper
  ];

  services = {
    ratbagd.enable = true;
    privoxy.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };

  virtualisation = {
    podman = {
      enable = false;
      dockerCompat = true;
    };
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm; # only emulates host arch, smaller download
        swtpm.enable = true; # allows for creating emulated TPM
      };
    };
  };
  boot.extraModulePackages = [];
  services.udev.packages = [];
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
  };
  programs.quark-goldleaf.enable = false; # TODO: reenable in the future
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/maix/Nixfiles"; # sets NH_OS_FLAKE variable for you
  };
}
