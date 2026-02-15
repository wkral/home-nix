{ pkgs, lib, inputs, ... }:
let
  inherit (pkgs) callPackage;
  inherit (lib) recurseIntoAttrs;
  newpkgs = {
    mkpdf = callPackage ./mkpdf { };
    quickcmd = callPackage ./quickcmd.nix { };
    texlive = callPackage ./texlive.nix { };

    vimPlugins = recurseIntoAttrs (callPackage ./vim-plugins {
      inherit (inputs) vim-colours;
    });
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      wk = recurseIntoAttrs newpkgs;
    })
  ];
}
