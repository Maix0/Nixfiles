{
  inputs,
  flake,
  extraInfo,
}: {
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.git.excludes = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  imports = [
    inputs.nix-index-database.hmModules.nix-index
    extraInfo
  ];

  config = {
    home.sessionVariables = rec {
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
      PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";

      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };

    home.packages = with pkgs; [
      bat
      comma
      fd
      file
      gef
      ltrace
      gnumake
      jq
      man-pages
      neovimMaix
      oscclip
      pandoc
      raclette
      ripgrep
      rsync
      tokei
      unzip
      wget
      ipmitool
      nix-output-monitor
      bat-extras.prettybat

      # Useful for pandoc to latex
      (texlive.combine {
        inherit
          (texlive)
          scheme-medium
          fncychap
          wrapfig
          capt-of
          framed
          upquote
          needspace
          tabulary
          varwidth
          titlesec
          ;
      })
    ];

    nix.registry = {
      "my".flake = flake;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
        }

        cargo_target_dir() {
          local path
          path="''${PWD//[^a-zA-Z0-9]/-}"
          echo "''${XDG_CACHE_HOME}/cargo/target''${path}"
        }

        : "''${CARGO_TARGET_DIR:="$(cargo_target_dir)"}"
        export CARGO_TARGET_DIR="$CARGO_TARGET_DIR"
      '';
    };

    programs.home-manager.enable = true;
    programs.bat = {
      enable = true;
      syntaxes = {
        meson = {
          src = inputs.meson-syntax;
          file = "meson.sublime-syntax";
        };
      };
    };
    programs.zoxide.enable = true;

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      lfs.enable = true;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          syntax-theme = "Dracula";
          plus-style = "auto \"#121bce\"";
          plus-emph-style = "auto \"#6083eb\"";
        };
      };

      excludes = ''
        .cache
        compile_commands.json
      '';

      extraConfig = {
        diff = {
          algorithm = "histogram";
        };
        core = {
          excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
        };
      };

      aliases = {
        ri = "rebase -i";
        amend = "commit --amend";
      };
    };

    home.file = {
      ".config/python/pythonrc".text = ''
        import os
        import atexit
        import readline

        history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
        try:
          readline.read_history_file(history)
        except OSError:
          pass

        def write_history():
          try:
            readline.write_history_file(history)
          except OSError:
            pass

        atexit.register(write_history)
      '';
    };
  };
}
