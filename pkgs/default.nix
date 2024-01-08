{ pkgs, lib, inputs, ... }:
let
  inherit (pkgs) callPackage;
  inherit (lib) recurseIntoAttrs;
  newpkgs = {
    last-commit-id = callPackage ./last-commit-id.nix { };
    mkpdf = callPackage ./mkpdf { };
    quickcmd = callPackage ./quickcmd.nix { };
    sway-dropdown-term = callPackage ./sway-dropdown-term.nix { };
    texlive = callPackage ./texlive.nix { };

    node-tools = recurseIntoAttrs (callPackage ./node-tools { });
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
