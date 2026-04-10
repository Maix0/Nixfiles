{
  inputs,
  lib,
  ...
}: let
  moduleName = "host-XeLaptop";
in {
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "XeLaptop";

  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      user-maix
      minimal
      gaming
      dev
      gui
      cli
    ];
    hardware = {
      bluetooth.enable = true;
      cpu.amd.updateMicrocode = true;
      graphics.enable = true;
      sane.enable = true;
    };
    boot = {
      supportedFilesystems = ["ntfs"];
      kernelParams = ["i8042.reset" "i8042.nomux" "i8042.nopnp" "i8042.noloop" "acpi"];
      binfmt.emulatedSystems = ["aarch64-linux"];
      initrd = {
        enable = true;
        availableKernelModules = ["amdgpu" "r8169"];
      };
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };
      kernel.sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = 0;
      };

      kernelPackages = lib.mkDefault pkgs.linuxPackages;
    };
    virtualisation.containers.enable = lib.mkForce false;

    programs = {
      zsh = {
        enable = lib.mkForce true;
        enableCompletion = true;
      };
      nix-ld = {
        enable = true;
        libraries = [];
      };
    };
    networking.networkmanager.enable = true;
    services = {
      ratbagd.enable = true;
      privoxy.enable = true;
      fwupd.enable = true;
      openssh.enable = true;
      tailscale = {
        enable = true;
      };
    };
    security = {
      polkit.enable = true;
      rtkit.enable = true;
      pam.services.login.fprintAuth = true;
    };
    powerManagement.enable = true;
    services = {
      power-profiles-daemon.enable = true;
      resolved.enable = true;
      fprintd.enable = true;
    };
    networking = {
      hostName = "XeLaptop";
      interfaces = {
        wlp1s0.useDHCP = true;
      };
      firewall.allowedTCPPorts = [8080 8085 5201 80 443];
    };
    system.stateVersion = "26.05";
  };

  flake.modules.nixos."${moduleName}-hw" = {
    pkgs,
    modulesPath,
    config,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
      initrd.kernelModules = [];
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1a57efa7-9946-449d-9254-f92dbbd3befc";
      fsType = "btrfs";
      options = ["defaults"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/236B-E80A";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
