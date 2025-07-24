{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Maieul BOYER";
    package = pkgs.gitAndTools.gitFull;
    userEmail = "maieul.dev@familleboyer.net";
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
        excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
      };
    };
    aliases = {
      ri = "rebase -i";
      amend = "commit --amend";
    };
  };
}
