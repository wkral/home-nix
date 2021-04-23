{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wk.work;
in
with lib;
{
  options.wk.work.enable = mkEnableOption "tools for work";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true; # required by zoom-us, teams

    home.packages = with pkgs; [
      teams

      pandoc
      graphviz
      plantuml
      librsvg
      wk.texlive

      #wk.mkpdf
    ];
  };
}
