{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    lollypop
    id3v2
  ];
}
