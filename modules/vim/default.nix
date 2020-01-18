{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.bash = {
    shellAliases = {
      vi = "vim";
    };
  };

  programs.vim =  {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
    plugins = let
      colours = pkgs.vimUtils.buildVimPlugin {
        name = "vim-colours";
        src = pkgs.fetchFromGitHub {
          owner = "wkral";
          repo = "vim-colours";
          rev = "28b0142aa73a6903b29174600cf8602c0eeb1d4d";
          sha256 = "0ihy6jp9chy7a8v4i6yj1zfbnj1h56hw9sbigzpykcfiqrzipkli";
        };
      };
      salt = pkgs.vimUtils.buildVimPlugin {
        name = "salt-vim";
        src = pkgs.fetchFromGitHub {
          owner = "saltstack";
          repo = "salt-vim";
          rev = "6ca9e3500cc39dd417b411435d58a1b720b331cc";
          sha256 = "0r79bpl98xcsmkw6dg83cf1ghn89rzsr011zirk3v1wfxclri2c4";
        };
      };
    in
    with pkgs.vimPlugins; [
      fugitive
      fzf-vim
      gitgutter
      vim-jinja
      lightline-vim
      #syntastic
      ale
      lightline-ale
      vim-fireplace
      vim-polyglot
      colours
      salt
    ];
  };
}
