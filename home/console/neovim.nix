{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
    colorschemes.dracula.enable = true;
    clipboard.register = "unnamedplus";
    extraConfigLuaPost = ''
      vim.cmd [[
        highlight Normal guibg=none
        highlight NonText guibg=none
        highlight Normal ctermbg=none
        highlight NonText ctermbg=none
      ]]
    '';
    autoCmd = [
      {
        event = "Filetype";
        pattern = [
          "markdown"
          "gitcommit"
        ];
        command = "setlocal spell";
      }
    ];
    filetype = {
      extension = {
        nu = "nu";
      };
    };
    opts = {
      smartindent = true;
      wildmode = [
        "longest"
        "list"
      ];
      linebreak = true;
      backspace = [
        "indent"
        "eol"
        "start"
      ];
      foldenable = false;
      cursorline = true;
      colorcolumn = "80";
      spelllang = "en_ca";
      exrc = true;
    };
    globals.mapleader = ",";
    keymaps = [
      {
        action = "<cmd>Telescope find_files<cr>";
        key = "<leader>t";
        mode = [ "n" ];
        options.noremap = true;
      }
      {
        action = "<cmd>Telescope buffers<cr>";
        key = "<leader>b";
        mode = [ "n" ];
        options.noremap = true;
      }
      {
        action = "<cmd>Telescope grep_string<cr>";
        key = "<leader>.";
        mode = [ "n" ];
        options.noremap = true;
      }
      {
        action = "<cmd>Telescope live_grep<cr>";
        key = "<leader>/";
        mode = [ "n" ];
        options.noremap = true;
      }
      {
        action = "<cmd>wincmd h<cr>";
        key = "<c-h>";
        mode = [ "n" ];
        options.noremap = true;
        options.silent = true;
      }
      {
        action = "<cmd>wincmd j<cr>";
        key = "<c-j>";
        mode = [ "n" ];
        options.noremap = true;
        options.silent = true;
      }
      {
        action = "<cmd>wincmd k<cr>";
        key = "<c-k>";
        mode = [ "n" ];
        options.noremap = true;
        options.silent = true;
      }
      {
        action = "<cmd>wincmd l<cr>";
        key = "<c-l>";
        mode = [ "n" ];
        options.noremap = true;
        options.silent = true;
      }
      {
        action = "(!&modifiable ? ':close!<CR>' : 'q')";
        key = "q";
        mode = [ "n" ];
        options.noremap = true;
        options.expr = true;
      }
    ];
    plugins = {
      fugitive.enable = true;
      gitsigns.enable = true;
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "dracula";
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                fmt = {
                  __raw = "function(str) return str:sub(1,1) end";
                };
              }
            ];
            lualine_c = [
              {
                __unkeyed-1 = "filename";
                path = 1;
                shorting_target = 40;
              }
            ];
          };
        };
      };
      lspconfig.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = false;
      };
      web-devicons.enable = true;
    };
    extraPlugins = [ pkgs.vimPlugins.vim-polyglot ];
    lsp = {
      keymaps = [

        {
          action.__raw = "vim.diagnostic.open_float";
          key = "<leader>e";
          mode = "n";
        }
        {
          action.__raw = "vim.diagnostic.goto_prev";
          key = "[d";
          mode = "n";
        }
        {
          action.__raw = "vim.diagnostic.goto_next";
          key = "]d";
          mode = "n";
        }
        {
          action.__raw = "vim.diagnostic.setloclist";
          key = "<leader>q";
          mode = "n";
        }
        {
          key = "gd";
          lspBufAction = "definition";
          mode = "n";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          mode = "n";
        }
        {
          key = "K";
          lspBufAction = "hover";
          mode = "n";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
          mode = "n";
        }
        {
          key = "<leader>D";
          lspBufAction = "type_definition";
          mode = "n";
        }
        {
          key = "<leader>rn";
          lspBufAction = "rename";
          mode = "n";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
          mode = "n";
        }
        {
          key = "gr";
          action = "<cmd>Telescope lsp_references<CR>";
          mode = "n";
        }
        {
          key = "<leader>f";
          lspBufAction = "format";
          mode = "n";
        }
      ];
      servers = {
        basedpyright.enable = true;
        rust-analyzer.enable = true;
        gopls.enable = true;
        golangci_lint_ls.enable = true;
        nixd = {
          enable = true;
          config = {
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
        nushell.enable = true;
        ruff.enable = true;
        ty.enable = true;
      };
    };
  };
}
