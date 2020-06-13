{ config, lib, pkgs, ... }:
let
  cfg = config.wk.clojure;
in
with lib;
{
  options.wk.clojure.enable = mkEnableOption "Clojure dev tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clojure
      leiningen
    ];
  };
}
