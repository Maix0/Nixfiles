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

  home.sessionVariables = {
    CARGO_TARGET_DIR = "${config.home.sessionVariables.HOME}/cargo-target";
  };

  services.syncthing.enable = true;

  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    LoServer = {
      hostname = "risoul.familleboyer.net";
      port = 22;
    };
  };

  home.file = {
    bin = {
      source = ./scripts;
      recursive = true;
    };
  };
}
