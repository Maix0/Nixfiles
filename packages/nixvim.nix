{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    inputs',
    ...
  }: let
    mkVim = m:
      inputs'.nixvim.legacyPackages.makeNixvimWithModule {
        module = {...}: {
          imports = m inputs.self.modules.nixvim;
        };
      };
  in {
    packages.nvimFull = mkVim (m: (builtins.attrValues m));
      #packages.nvim = self'.packages.nvimFull;
      #
      #app.nvimFull = {
      #meta.description = "Nvim with full configuration";
      #program = self'.packages.nvimFull;
      #type = "app";
      #};
      #app.nvim = {
      #meta.description = "Default Nvim Configuration";
      #program = self'.packages.nvim;
      #type = "app";
      #};
  };
}
