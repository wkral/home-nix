{ config, lib, pkgs, ... }:
let
  cfg = config.wk.calibre;
in
with lib;
{
  options.wk.calibre.enable = mkEnableOption "Calibre eBooks";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
