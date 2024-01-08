{ vim, vimUtils, vim-colours }:
let
  inherit (vimUtils.override { inherit vim; }) buildVimPlugin;
in
{
  colours = buildVimPlugin {
    name = "vim-colours";
    pname = "vim-colours";
    src = vim-colours;
  };
}
