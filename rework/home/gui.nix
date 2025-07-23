{pkgs, ...}: {
  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };
}
