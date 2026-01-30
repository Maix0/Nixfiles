{myPkgs, ...}: {
  services.hyprpaper = {
    settings = {
      preload = ["${./background.png}"];
      wallpaper = [", ${./background.png}"];
      ipc = true;
      splash = true;
    };
    enable = true;
  };
}
