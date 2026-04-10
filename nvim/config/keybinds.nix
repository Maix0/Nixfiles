{
  inputs,
  lib,
  ...
}: let
  moduleName = "keybinds";
in {
  flake.modules.nixvim.${moduleName} = {pkgs, lib, ...}: {
    keymaps = let
      modeKeys = mode:
        lib.attrsets.mapAttrsToList (key: action:
          {
            inherit key mode;
          }
          // (
            if builtins.isString action
            then {inherit action;}
            else action
          ));
      all_mode = modeKeys ["n" "v" "i"];
      nm = modeKeys ["n"];
      vs = modeKeys ["v"];
      im = modeKeys ["i"];
    in
      lib.nixvim.keymaps.mkKeymaps {options.silent = true;} (
        (all_mode {
          "<A-Left>" = "<C-w><Left>";
          "<A-Right>" = "<C-w><Right>";
          "<A-Up>" = "<C-w><Up>";
          "<A-Down>" = "<C-w><Down>";
          "<S-A-Left>" = "<C-w><";
          "<S-A-Right>" = "<C-w>>";
          "<S-A-Up>" = "<C-w>+";
          "<S-A-Down>" = "<C-w>-";
          "<C-:>" = "<Plug>(comment_toggle_linewise_current)";
          "<C-/>" = "<Plug>(comment_toggle_linewise_current)";
          "<C-s>" = "<cmd>w<CR>";
        })
        ++ (
          nm {
            "ft" = "<cmd>Neotree<CR>";
            "fG" = "<cmd>Neotree git_status<CR>";
            "fR" = "<cmd>Neotree remote<CR>";
            "fc" = "<cmd>Neotree close<CR>";
            "bp" = "<cmd>Telescope buffers<CR>";

            "<leader>w" = "<cmd>Telescope grep_string<CR>";
            "<leader>q" = "<cmd>Telescope live_grep<CR>";
            "<leader>d" = "<cmd>Telescope diagnostics bufnr=0<CR>";
            "<leader>D" = "<cmd>Telescope diagnostics<CR>";

            "mk" = "<cmd>Telescope keymaps<CR>";
            "fg" = "<cmd>Telescope git_files<CR>";
            "gr" = "<cmd>Telescope lsp_references<CR>";
            "gI" = "<cmd>Telescope lsp_implementations<CR>";
            "gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
            "gF" = "<cmd>Telescope lsp_document_symbols<CR>";

            "<leader>h" = {
              action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
              options = {
                desc = "toggle inlay hints";
              };
            };
            "yH" = {
              action = "<Cmd>Telescope yank_history<CR>";
              options.desc = "history";
            };
          }
        )
        ++ (vs {
          "x" = "dl<CR>";
        })
        ++ (im {})
        ++ [
          {
            key = "<leader>r";
            mode = ["n"];
            action = lib.nixvim.mkRaw ''
              function()
              	return ":IncRename " .. vim.fn.expand("<cword>")
              end
            '';
            options.expr = true;
          }
        ]
      );
  };
}
