{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      commit.gpgsign = true;
      core.excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
      diff.algorithm = "histogram";
      gpg.format = "ssh";
      init.defaultBranch = "master";
      alias = {
        ri = "rebase -i";
        amend = "commit --amend";
        lg = "log --graph --pretty=format:'%C(red)%h%Creset %C(yellow)%an%Creset %C(white)%s%Creset%C(red)%d %C(green)(%ad)%Creset' --date=relative";
      };
      user = {
        name = "Maieul BOYER";
        email = "maieul.dev@familleboyer.net";
        signingkey = "/home/maix/.ssh/id_ed25519.pub";
      };
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      syntax-theme = "Dracula";
      plus-style = "auto \"#121bce\"";
      plus-emph-style = "auto \"#6083eb\"";
    };
  };
}
