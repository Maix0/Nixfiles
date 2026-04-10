{
  inputs,
  lib,
  ...
}: let
  moduleName = "minimal";
in {
  flake.modules.nixos.${moduleName} = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      min-greet
      min-nix
    ];

    i18n.defaultLocale = "en_GB.UTF-8";
    console = {
      packages = [pkgs.terminus_font];
      font = "ter-v32n";
      keyMap = "us";
    };
    time.timeZone = "Europe/Paris";
    environment = {
      extraInit = ''
        [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      '';
      pathsToLink = ["/share/zsh"];
    };
    environment.defaultPackages = [pkgs.brightnessctl];
  };

  flake.modules.homeManager.${moduleName} = {pkgs, ...}: {
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

    programs = {
      bat.enable = true;
      zoxide.enable = true;
      ssh.enable = true;
    };
  };
}
