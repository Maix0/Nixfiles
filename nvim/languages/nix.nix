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
      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          nix
        ]);

      lsp.servers.nil_ls = {
        enable = true;
        settings.formatting.command = ["${lib.getExe pkgs.alejandra}" "--quiet"];
      };
    };

    files = {
      "ftplugin/nix.lua" = {
        opts = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
        };
      };
    };
  };
}
