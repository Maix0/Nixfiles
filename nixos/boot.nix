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
  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
    graphics.enable = true;
    sane.enable = true;
  };
}
