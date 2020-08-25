{ config, lib, pkgs, ... }:
let
  cfg = config.wk.games;
in
with lib;
{
  options.wk.games.enable = mkEnableOption "Gaming";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      steam
      steam-run
      lutris
    ];
  };
}
