{ ... }:

{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.users.maix = (import /etc/nixos/maix/home.nix);
}
