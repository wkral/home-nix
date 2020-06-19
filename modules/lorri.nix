{ config, lib, pkgs, ... }:
let
  cfg = config.wk.lorri;
in
with lib;
{
  options.wk.lorri.enable = mkEnableOption "lorri";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv
    ];

    services.lorri.enable = true;
  };
}
