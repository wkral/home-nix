{ config, lib, pkgs, ... }:
let
  cfg = config.wk.cad;
in
with lib;
{
  options.wk.cad.enable = mkEnableOption "Clojure dev tools";

  config = mkIf cfg.enable {
    wk.clojure.enable = true;

    home.packages = [
      pkgs.openscad
    ];
  };
}
