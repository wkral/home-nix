{ config, lib, pkgs, ... }:
with lib;
let
  fixers = config.wk.vim.ale-fixers;
  linters = config.wk.vim.ale-linters;
  vim-str = str: "'${str}'";
  vim-list = list: "[${concatMapStringsSep ", " vim-str list}]";
  keyed-list = key: items: "\\   ${vim-str key}: ${vim-list items},";
  ale-config = ''

    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    ${concatStringsSep "\n" (mapAttrsToList keyed-list fixers)}
    \}

    let g:ale_linters = {
    ${concatStringsSep "\n" (mapAttrsToList keyed-list linters)}
    \}
  '';
in
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      fugitive
      plenary-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require'lspconfig'.rust_analyzer.setup{}
        '';
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            ensure_installed = "all",
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
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
            sections = {
              lualine_a = {
                { 'mode', fmt = function(str) return str:sub(1,1) end }
              },
            }
          }
        '';
      }
      editorconfig-nvim
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

      let mapleader=","

      nnoremap <silent> <c-h> :wincmd h<cr>
      nnoremap <silent> <c-j> :wincmd j<cr>
      nnoremap <silent> <c-k> :wincmd k<cr>
      nnoremap <silent> <c-l> :wincmd l<cr>
    '';
  };
}
