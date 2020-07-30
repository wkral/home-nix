{ pkgs, lib, ... }:
let
  inherit (pkgs) callPackage;
  inherit (lib) recurseIntoAttrs;
  newpkgs = {
    last-commit-id = callPackage ./last-commit-id.nix { };
    lua-filters = callPackage ./lua-filters.nix { };
    mkpdf = callPackage ./mkpdf { };
    newbranch = callPackage ./newbranch.nix { };
    quickcmd = callPackage ./quickcmd { };
    sway-dropdown-term = callPackage ./sway-dropdown-term.nix { };
    texlive = callPackage ./texlive.nix { };
    vagrant-halt-all = callPackage ./vagrant-halt-all.nix { };
    vsh = callPackage ./vsh.nix { };

    node-tools = recurseIntoAttrs (callPackage ./node-tools { });
    vimPlugins = recurseIntoAttrs (callPackage ./vim-plugins { });
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      wk = recurseIntoAttrs newpkgs;
    })
  ];
}
