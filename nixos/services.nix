{pkgs, ...}: {
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    avahi = {
      nssmdns4 = true;
      enable = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        gutenprint
        gutenprintBin
      ];
    };
  };
}
