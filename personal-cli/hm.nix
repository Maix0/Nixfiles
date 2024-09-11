{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-cli
    kabalist_cli
    tokei
    xdg-ninja
    zk
    htop
    tree
    socat
    fastmod
    nixpkgs-fmt
    nixpkgs-review
    nix-init
  ];

  services.syncthing.enable = true;

  programs.ssh.enable = true;
  programs.ssh.matchBlocks = rec {
    LoServer = {
      hostname = "risoul.familleboyer.net";
      port = 22;
    };
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
  };
}
