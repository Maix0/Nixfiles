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
      gpg.format = "ssh";
      user.signingkey = "/home/maix/.ssh/id_ed25519.pub";
      commit.gpgsign = true;
    };
    aliases = {
      ri = "rebase -i";
      amend = "commit --amend";
      lg = "log --graph --pretty=format:'%C(red)%h%Creset %C(yellow)%an%Creset %C(white)%s%Creset%C(red)%d %C(green)(%ad)%Creset' --date=relative";
    };
  };
}
