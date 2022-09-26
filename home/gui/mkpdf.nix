{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    pandoc
    librsvg
    plantuml
    graphviz
    wk.mkpdf
    wk.texlive
  ];
}
