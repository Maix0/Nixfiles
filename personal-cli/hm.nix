{pkgs, config, ...}: {
  home.packages = with pkgs; [
    bitwarden-cli
    hbw
    kabalist_cli
    nix-alien
    nvfetcher
    tokei
    xdg-ninja
    zk
    htop
    tree
    socat
    fastmod
  ];

  services.syncthing.enable = true;

  programs.ssh.enable = true;
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+="$HOME/.zfunc"
  '';

  programs.ssh.matchBlocks = rec {
    ZeServe = {
      hostname = "familleboyer.net";
      port = 10022;
    };
    ZeServer = ZeServe;
    LoBootstrap = {
      hostname = "familleboyer.net";
      port = 20022;
      identityFile = "/home/${config.extraInfo.username}/.ssh/risoul_bootstrap";
    };
  };

  home.file = {
    bin = {
      source = ./scripts;
      recursive = true;
    };
    ".zfunc" = {
      source = ./zfunc;
      recursive = true;
    };
  };
}
