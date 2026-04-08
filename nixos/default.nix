{...}: {
  imports = [
    ./boot.nix
    ./cachix.nix
    ./greet.nix
    ./gui.nix
    ./hardware-configuration.nix
    ./minimal.nix
    ./nixos.nix
    ./postgres.nix
    ./security.nix
    ./services.nix
    ./steam.nix
    ./virtualbox.nix
    ./waydroid.nix
  ];

  system.stateVersion = "25.11";
}
