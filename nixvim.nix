{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
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
        action = "<cmd>Neotree left<CR>";
        key = "<leader>s";
        options = {
          desc = "Open Neotree on the side";
        };
      }
      {
        action = "<cmd>FzfLua files<CR>";
        key = "<leader>f";
        options = {
          desc = "Fuzzy find files";
        };
      }
      {
        action = "<cmd>FzfLua live_grep<CR>";
        key = "<leader>/";
        options = {
          desc = "Fuzzy find words";
        };
      }
    ];

    # trying to fix rust lsp error
    extraConfigLua = ''
      for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
          local default_diagnostic_handler = vim.lsp.handlers[method]
          vim.lsp.handlers[method] = function(err, result, context, config)
              if err ~= nil and err.code == -32802 then
                  return
              end
              return default_diagnostic_handler(err, result, context, config)
          end
      end 
    '';

    extraConfigVim = ''
      set number
      colorscheme catppuccin-macchiato
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set relativenumber
      set path+=**
      '';
    plugins = {
      web-devicons.enable = true;
      fzf-lua.enable = true;
      neo-tree = {
        enable = true;
        sources = [
          "filesystem"
          "buffers"
          "git_status"
          "document_symbols"
        ];
        window.mappings = {
          "y" = "copy";
          "<esc>" = "revert_preview";
          "d" = "delete";
          "m" = "move";
          "r" = "rename";
        };
        extraOptions = {
          popup_border_style = "rounded";
        };
      };
      cmp = {
        enable = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
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
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          "<C-l>" = ''
            cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' })
          '';
          "<C-h>" = ''
            cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' })
          '';
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };

          pylsp.enable = true;

          # for typst autocomplete
          tinymist.enable = true;

          matlab_ls.enable = true;
          ts_ls.enable = true;
          superhtml.enable = true;
        };
      };
      # Trying to get cmp to work
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
      plantuml-syntax.enable = true;
      
    };
    extraPlugins = [ 
      (pkgs.vimUtils.buildVimPlugin {
        name = "ethersync";
        src = pkgs.fetchFromGitHub {
            owner = "ethersync";
            repo = "ethersync-vim";
            rev = "42f3ae9cf6f58616232598dc076b93a8a41aea4e";
            hash = "sha256-o+LMK8yTw/hHZmB1tnRTR6C086kLME5EzLpIN6n2MGE=";
        };
      })
    ];
  };
}
