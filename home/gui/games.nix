{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    steam
    steam-run
  ];
}
