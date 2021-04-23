{ config, lib, pkgs, ... }:
let
  cfg = config.wk.zoom;
in
with lib;
{
  options.wk.zoom.enable = mkEnableOption "Zoom Video Conferencing";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true; # required by zoom

    home.packages = with pkgs; [
      zoom-us
      v4l-utils
    ];
  };
}
