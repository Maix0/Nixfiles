{...}: {
  config = {
    virtualisation.virtualbox.host = {
      enable = true;
      #enableExtensionPack = true;
    };
    users.extraGroups.vboxusers.members = ["maix"];
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];
  };
}
