{
  inputs,
  lib,
  ...
}: let
  moduleName = "rust";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }: {
    plugins = {
      rustaceanvim = {
        enable = true;
        settings.server.default_settings.rust-analyzer = {
          cmd = ["${lib.getExe pkgs.rust-analyzer}"];
          rust-analyzer = {
            check.command = "clippy";
            cargo.features = "all";
            rustc.source = "discover";
            checkOnSave = true;
            inlayHints.lifetimeElisionHints.enable = "always";
          };
        };
      };
      lsp.servers.taplo.enable = true;
      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          rust
          toml
        ]);
    };
  };
}
