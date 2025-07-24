{...}: {
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
}
