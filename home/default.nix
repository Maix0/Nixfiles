{...}: {
  imports = [
    ./browser.nix
    ./direnv.nix
    ./env.nix
    ./git.nix
    ./gui.nix
    ./minimal.nix
    ./programs.nix
    ./terminal.nix
    ./gaming.nix
    ./wm/idle.nix
    ./wm/land.nix
    ./wm/lock.nix
    ./wm/mako.nix
    ./wm/paper.nix
    ./wm/waybar.nix
  ];

  home.stateVersion = "25.11";
}
