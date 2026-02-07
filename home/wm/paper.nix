{myPkgs, ...}: {
  services.hyprpaper = {
    settings = {
      preload = ["${./background.png}"];
      wallpaper = [
        {
          monitor = "";
          path = "${./background.png}";
        }
      ];
      ipc = true;
      splash = true;
    };
    enable = true;
  };
}
