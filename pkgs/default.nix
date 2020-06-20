{ pkgs, lib, ... }:
let
  inherit (pkgs) callPackage;
  inherit (lib) recurseIntoAttrs;
  newpkgs = {
    last-commit-id = callPackage ./last-commit-id.nix { };
    lua-filters = callPackage ./lua-filters.nix { };
    mkpdf = callPackage ./mkpdf { };
    move-workspace = callPackage ./move-workspace.nix { };
    newbranch = callPackage ./newbranch.nix { };
    quickcmd = callPackage ./quickcmd { };
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
