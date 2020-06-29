{ config, lib, pkgs, ... }:
with lib;
let
  fixers = config.wk.vim.ale-fixers;
  vim-str = str: "'${str}'";
  vim-list = list: "[${concatMapStringsSep ", " vim-str list}]";
  lang-fixers = lang: progs: "\\   ${vim-str lang}: ${vim-list progs},";
  ale-config = ''

    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    ${concatStringsSep "\n" (mapAttrsToList lang-fixers fixers)}
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
