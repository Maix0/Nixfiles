{pkgs, ...}: {
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
  };

  networking = {
    hostName = "XeLaptop";
    interfaces = {
      wlp1s0.useDHCP = true;
    };
    firewall.allowedTCPPorts = [8080 8085 5201 80 443];
  };

  users = {
    users.maix.uid = 1000;
    groups.localtimed = {};
    groups.docker = {};
  };

  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
  };
  services = {
    fprintd = {
      enable = true;
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
      ensureUsers = [
        {
          name = "maix";
          ensureClauses = {
            superuser = true;
            login = true;
          };
        }
      ];
      ensureDatabases = ["list" "regalade"];
    };
  };

  security.pam.services.login.fprintAuth = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
