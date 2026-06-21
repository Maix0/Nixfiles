{inputs, ...}: let
  moduleName = "c-cpp";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    lib,
    ...
  }: {
    filetype.extension = {
      c__TEMPLATE__ = "c";
      h__TEMPLATE__ = "c";
    };
    plugins = {
      headerguard.enable = true;
      clangd-extensions = {
        enable = true;
        enableOffsetEncodingWorkaround = true;

        settings = {
          inlay_hints = {
            right_align = true;
            right_align_padding = 4;
            inline = false;
          };
          ast = {
            role_icons = {
              type = "";
              declaration = "";
              expression = "";
              specifier = "";
              statement = "";
              templateArgument = "";
            };
            kind_icons = {
              compound = "";
              recovery = "";
              translationUnit = "";
              packExpansion = "";
              templateTypeParm = "";
              templateTemplateParm = "";
              templateParamObject = "";
            };
          };
        };
      };

      treesitter.grammarPackages =
        lib.optionals
        config.plugins.treesitter.enable
        (with config.plugins.treesitter.package.passthru.builtGrammars; [
          c
          cpp
          make
          meson
          ninja
        ]);
      lsp.servers.clangd.enable = true;
    };
    extraConfigLuaPost = ''

      function avrClangd()
        vim.lsp.enable("clangd", false)
        local avr_gcc = vim.fn.exepath("avr-gcc")
        if avr_gcc == "" then
          vim.notify("No avr-gcc found", vim.log.levels.ERROR)
        else
          vim.notify("avr-gcc found at "..avr_gcc, vim.log.levels.INFO)
        end

        vim.lsp.config("clangd", { cmd = { "clangd", "--query-driver=" .. avr_gcc }})

        vim.lsp.enable("clangd")
      end

      vim.api.nvim_create_user_command(
        "AvrClangd",
        avrClangd,
        { desc = "Switch to clangd with avr-gcc query driver" }
      )
      project_hooks = {
        ["/home/maix/school/megasplonk/SplonkOS"] = avrClangd,
      }
    '';

    autoCmd = [
      {
        event = ["VimEnter"];
        callback = lib.nixvim.mkRaw ''
          function()
            local file = vim.api.nvim_buf_get_name(0)
            local root = file ~= "" and vim.fs.root(file, { ".git", "flake.nix" })

            local hook = project_hooks[root]
            if hook then
              hook()
            end
          end
        '';
      }
    ];
  };
}
