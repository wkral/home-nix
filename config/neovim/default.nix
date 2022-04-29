{ config, lib, pkgs, ... }:
with lib;
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = dracula-vim;
        config = ''
          autocmd ColorScheme * highlight Normal ctermbg=None
          autocmd ColorScheme * highlight NonText ctermbg=None
          colorscheme dracula
        '';
      }
      editorconfig-nvim
      fugitive
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup()
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'dracula'
            },
            sections = {
              lualine_a = {
                { 'mode', fmt = function(str) return str:sub(1,1) end }
              },
              lualine_c = {
                { 'filename', path = 1, shorting_target = 40 }
              },
            }
          }
        '';
      }
      plenary-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {})

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer=0 }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
            vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
            vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, opts)
          end

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = { 'rust_analyzer', 'rnix' }
          for _, lsp in pairs(servers) do
            require('lspconfig')[lsp].setup {
              on_attach = on_attach,
            }
          end
        '';
      }
      {
        plugin = (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = {
              enable = true,
            }
          }
        '';
      }
      {
        plugin = telescope-nvim;
        type = "viml";
        config = ''
          let mapleader=","
          nnoremap <leader>t <cmd>Telescope find_files<cr>
          nnoremap <leader>. <cmd>Telescope grep_string<cr>
          nnoremap <leader>/ <cmd>Telescope live_grep<cr>
        '';
      }
      vim-polyglot
    ];
    withRuby = false;
    withPython3 = false;
    extraConfig = ''

      set title "Window title for vim
      set smartindent "Indentation that doesn't suck
      set wildmode=longest,list "more bashy tab competion for file paths
      set linebreak "if you're going to wrap do it right
      set backspace=indent,eol,start "Let my backspace fly
      set nofoldenable "I don't like code folding
      set cursorline "show which line I'm on
      set colorcolumn=80 "better version of 80 column editing
      set clipboard=unnamedplus "Use system clipboard

      let mapleader=","

      nnoremap <silent> <c-h> :wincmd h<cr>
      nnoremap <silent> <c-j> :wincmd j<cr>
      nnoremap <silent> <c-k> :wincmd k<cr>
      nnoremap <silent> <c-l> :wincmd l<cr>

      " Close the quickfix and other windows with a q
      nnoremap <expr> q (!&modifiable ? ':close!<CR>' : 'q')

      au BufNewFile,BufRead * match ExtraWhitespace /\s\s\+$/
      match ExtraWhitespace /\s\s\+$/

      "Spell checking
      set spelllang=en_ca

      autocmd Filetype markdown setlocal spell
      autocmd Filetype gitcommit setlocal spell
    '';
  };
}
