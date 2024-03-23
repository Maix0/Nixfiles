{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bottles
    # TODO: heroic is broken (see nixos/nixpkgs#264156)
    # heroic
    lutris
  ];
}
