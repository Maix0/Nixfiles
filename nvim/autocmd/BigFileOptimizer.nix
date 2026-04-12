{
  inputs,
  lib,
  ...
}: let
  moduleName = "bigFileOptimizer";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    lib,
    ...
  }: {
    autoGroups.BigFileOptimizer = {};
    autoCmd = [
      {
        event = "BufReadPost";
        pattern = [
          "*.md"
          "*.rs"
          "*.lua"
          "*.sh"
          "*.bash"
          "*.zsh"
          "*.js"
          "*.jsx"
          "*.ts"
          "*.tsx"
          "*.c"
          ".h"
          "*.cc"
          ".hh"
          "*.cpp"
          ".cph"
        ];
        group = "BigFileOptimizer";
        callback = lib.nixvim.mkRaw ''
          function(auEvent)
            local bufferCurrentLinesCount = vim.api.nvim_buf_line_count(0)

            if bufferCurrentLinesCount > 2048 then
              vim.notify("bigfile: disabling features", vim.log.levels.WARN)

              vim.g.matchup_matchparen_enabled = 0
              -- vim.cmd("TSBufDisable refactor.highlight_definitions")
              -- require("nvim-treesitter.configs").setup({
              --  matchup = {
              --   enable = false
              --  }
              -- })
            end
          end
        '';
      }
    ];
  };
}
