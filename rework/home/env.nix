{
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = rec {
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      CARGO_TARGET_DIR = "${config.home.sessionVariables.HOME}/cargo-target";

      DELTA_PAGER = "${pkgs.less}/bin/less --mouse -R";
      DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
      PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";

      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";

      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = 1;
      MOZ_ENABLE_WAYLAND = "1";
      NIXPKGS_ALLOW_UNFREE = 1;
      EXA_COLORS = "xx=38;5;8";
    };
  };
}
