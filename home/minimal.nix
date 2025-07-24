{
  pkgs,
  lib,
  config,
  myPkgs,
  ...
}: {
  options.programs.git.excludes = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  config = {
    home = {
      file = {
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

    services.syncthing.enable = true;
    programs = {
      home-manager.enable = true;
      bat.enable = true;
      zoxide.enable = true;
      ssh = {
        enable = true;
        matchBlocks = {
          LoServer = {
            hostname = "risoul.familleboyer.net";
            port = 22;
          };
        };
      };
    };
  };
}
