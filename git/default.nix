{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
<<<<<<< HEAD
    userName = "Maieul BOYER";
=======
    userName = "traxys";
>>>>>>> 9d7e1172ba612e06676d429483765214d144c40e
    userEmail = config.extraInfo.email;
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        syntax-theme = "Dracula";
        plus-style = "auto \"#121bce\"";
        plus-emph-style = "auto \"#6083eb\"";
      };
    };
    extraConfig = {
      diff = {
        algorithm = "histogram";
      };
      core = {
        excludesfile = "${config.home.homeDirectory}/.gitignore";
      };
    };
  };

  home.file = {
    ".gitignore".source = ./gitignore;
  };
}
