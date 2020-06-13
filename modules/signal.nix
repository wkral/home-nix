{ config, lib, pkgs, ... }:
let
  cfg = config.wk.signal;
in
with lib;
{
  options.wk.signal.enable = mkEnableOption "Signal messenger";

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.signal-desktop
    ];
  };
}
