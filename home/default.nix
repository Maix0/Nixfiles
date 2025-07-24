{...}: {
  imports = [
    ./direnv.nix
    ./env.nix
    ./git.nix
    ./gui.nix
    ./minimal.nix
    ./programs.nix
    ./terminal.nix
    ./wm/idle.nix
    ./wm/land.nix
    ./wm/lock.nix
    ./wm/mako.nix
    ./wm/waybar.nix
  ];

  home.stateVersion = "25.11";
}
