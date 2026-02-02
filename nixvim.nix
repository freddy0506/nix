{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    #colorschemes.catppuccin.enable = true;
    colorschemes.monokai-pro.enable = true;
    defaultEditor = true;

    globals.mapleader = " ";
    keymaps = [
      {
        action = "<cmd>Neotree float<CR>";
        key = "<leader> ";
        options = {
          desc = "Open Neotree as floating window";
        };
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>sf";
        options = {
          desc = "Fuzzy find files";
        };
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>sw";
        options = {
          desc = "Fuzzy find words";
        };
      }
      {
        action = "<cmd>Telescope keymaps<CR>";
        key = "<leader>sk";
        options = {
          desc = "Fuzzy find words";
        };
      }
      {
        action = "<cmd>noh<CR>";
        key = "<esc><esc>";
        options = {
          desc = "Unmark search";
        };
      }
    ];


    extraConfigVim = ''
      set number
      set expandtab
      set tabstop=2 softtabstop=2 shiftwidth=2
      set relativenumber
      set path+=**
      '';
    plugins = {
      # fancy icons
      web-devicons.enable = true;

      # search files
      telescope.enable = true;

      # for snippets
      luasnip.enable = true;
      friendly-snippets.enable = true;

      parinfer-rust.enable = true;

      markdown-preview.enable = true;
      which-key = {
        enable = true;
        settings.delay = 500;
      };

      teamtype.enable = true;

      treesitter = {
        enable = true;
        # settings.highlight.enable = true;
        # settings.indent.enable = true;
        # settings.incremental_selection.enable = true;
    
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          java
          rust
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };

      # file tree
      neo-tree = {
        enable = true;
        /*
        window.mappings = {
          "y" = "copy";
          "<esc>" = "revert_preview";
          "d" = "delete";
          "m" = "move";
          "r" = "rename";
          "o" = "system_open";
          };*/
        settings = {
          sources = [
            "filesystem"
              "buffers"
              "git_status"
              "document_symbols"
          ];

          popup_border_style = "rounded";
          commands = {
            system_open.__raw = ''
              function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.jobstart({ "xdg-open", path }, { detach = true })
              end
              '';
          };
        };
      };

      # lsps
      cmp = {
        enable = true;
        luaConfig.pre = ''
        local luasnip = require("luasnip")
        '';
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
        ];

        # copy pasted mapping
        settings.mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          # "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          #    "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          # "<C-l>" = ''
          #   cmp.mapping(function()
          #     if luasnip.expand_or_locally_jumpable() then
          #       luasnip.expand_or_jump()
          #     end
          #   end, { 'i', 's' })
          # '';
          # "<C-h>" = ''
          #   cmp.mapping(function()
          #     if luasnip.locally_jumpable(-1) then
          #       luasnip.jump(-1)
          #     end
          #   end, { 'i', 's' })
          # '';
        };
      };


      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          # rust lsp
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };

          # pyhton lsp
          pylsp.enable = true;

          # typst lsp
          tinymist.enable = true;

          java_language_server.enable = true;
          superhtml.enable = true;
          nixd.enable = true;
          clangd.enable = true;
          ts_ls.enable = true;
        };
      };
    };
  };
}
