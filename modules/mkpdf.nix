
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wk.mkpdf;
in
with lib;
{
  options.wk.mkpdf.enable = mkEnableOption "Create PDFs from Markdown";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pandoc
      librsvg
      plantuml
      graphviz
      wk.mkpdf
      wk.texlive
      jre
    ];
  };
}
