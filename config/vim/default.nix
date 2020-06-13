{ pkgs, ... }:
{
  nixpkgs.config.vim.gui = "false";

  programs.vim = {
    extraConfig = builtins.readFile ./vimrc;
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
