{
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = rec {
      ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
      BROWSER = "zen";
      
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      CARGO_TARGET_DIR = "${config.home.sessionVariables.HOME}/cargo-target";
      
      CLUTTER_BACKEND = "wayland";
      DELTA_PAGER = "${pkgs.less}/bin/less --mouse -R";
      
      DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
      EXA_COLORS = "xx=38;5;8";
      GDK_BACKEND = "wayland,x11";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      
      HOME = "/home/maix";
      LIBSEAT_BACKEND = "logind";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      MOZ_ENABLE_WAYLAND = "1";
      
      NIXOS_OZONE_WL = 1;
      NIXPKGS_ALLOW_UNFREE = 1;
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
      PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
      
      QT_QPA_PLATFORM = "wayland";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      
      SDL_VIDEODRIVER = "wayland";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";
      
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
      
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
  };
}
