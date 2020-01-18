{ pkgs, ... }:

let
  newdoc = pkgs.writeShellScriptBin "newdoc" (builtins.readFile ./newdoc);
in
{
  home.packages = with pkgs; [
    newdoc
    graphviz
    pandoc
    plantuml
    texlive.combined.scheme-medium
  ];
}
