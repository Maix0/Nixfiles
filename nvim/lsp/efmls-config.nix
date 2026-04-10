{
  inputs,
  lib,
  ...
}: let
  moduleName = "efmls-config";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    lib,
    ...
  }: {
    plugins.efmls-configs = {
      enable = true;

      toolPackages.mdformat = pkgs.mdformat;
      languages = {
        htmldjango = {
          formatter = [(lib.nixvim.mkRaw "djlint_fmt")];
          linter = "djlint";
        };

        bash = {formatter = "shfmt";};
        c = {linter = "cppcheck";};
        css = {formatter = "prettier";};
        gitcommit = {linter = "gitlint";};
        html = {formatter = ["prettier" (lib.nixvim.mkRaw "djlint_fmt")];};
        javacript = {formatter = "prettier";};
        json = {formatter = "prettier";};
        lua = {formatter = "stylua";};
        markdown = {formatter = ["cbfmt" "mdformat"];};
        nix = {linter = "statix";};
        python = {formatter = "black";};
        sh = {formatter = "shfmt";};
        typescript = {formatter = "prettier";};
      };
    };
  };
}
