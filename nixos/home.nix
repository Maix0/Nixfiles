{...}: {
  imports = [
    <home-manager/nixos>
  ];
  home-manager.useGlobalPkgs = true;
<<<<<<< HEAD
  home-manager.users.maix = (import /etc/nixos/maix/home.nix);
=======
  home-manager.users.traxys = import /etc/nixos/traxys/home.nix;
>>>>>>> 9d7e1172ba612e06676d429483765214d144c40e
}
