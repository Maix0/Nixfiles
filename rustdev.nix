{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    rustup
    cargo-edit
    cargo-expand
  ];
}
