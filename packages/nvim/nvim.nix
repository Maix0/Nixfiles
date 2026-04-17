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
          imports = builtins.attrValues (m inputs.self.modules.nixvim);
        };
      };
    removeAttrs' = names: attr: builtins.removeAttrs attr names;
  in {
    packages = {
      nvimFull = mkVim (m: m);
      nvim = self'.packages.nvimFull;
      nvimNoClipboard = mkVim (removeAttrs' ["clipboard"]);
    };
    apps = {
      nvimFull = {
        meta.description = "Nvim with full configuration";
        program = self'.packages.nvimFull;
        type = "app";
      };
      nvim = {
        meta.description = "Default Nvim Configuration";
        program = self'.packages.nvim;
        type = "app";
      };
    };
  };
}
