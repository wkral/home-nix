{ config, lib, pkgs, ... }:
let
  cfg = config.wk.music;
in
with lib;
{
  options.wk.music.enable = mkEnableOption "Music";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lollypop
      id3v2
    ];
  };
}
