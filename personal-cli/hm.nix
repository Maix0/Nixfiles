{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-cli
    bottom
    fastmod
    htop
    kabalist_cli
    nix-init
    nixpkgs-fmt
    nixpkgs-review
    socat
    tokei
    tree
    zk
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
}
