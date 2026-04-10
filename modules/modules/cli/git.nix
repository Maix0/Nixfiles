{
  inputs,
  lib,
  ...
}: let
  moduleName = "cli-git";
in {
  flake.modules.homeManager.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        commit.gpgsign = true;
        diff.algorithm = "histogram";
        gpg.format = "ssh";
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
        alias = {
          ri = "rebase -i";
          amend = "commit --amend";
          lg = "log --graph --pretty=format:'%C(red)%h%Creset %C(yellow)%an%Creset %C(white)%s%Creset%C(red)%d %C(green)(%ad)%Creset' --date=relative";
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
  };
}
