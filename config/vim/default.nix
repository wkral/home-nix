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
  #nixpkgs.config.vim.gui = "false";

  programs.vim = {
    extraConfig = (builtins.readFile ./vimrc) + ale-config ;
    plugins = with pkgs.vimPlugins; with pkgs.wk.vimPlugins; [
      fugitive
      fzf-vim
      gitgutter
      vim-jinja
      lightline-vim
      ale
      lightline-ale
      vim-fireplace
      vim-polyglot
      colours
      salt
    ];
  };
}
