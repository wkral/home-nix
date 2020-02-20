{ pkgs, ... }:

let
  newdoc = pkgs.writeShellScriptBin "newdoc" (builtins.readFile ./newdoc);
in
{
  home.packages = with pkgs; [
    newdoc
    librsvg
    graphviz
    pandoc
    plantuml
    texlive.combined.scheme-medium
  ];
}
