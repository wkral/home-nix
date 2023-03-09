{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    zoom-us
    v4l-utils
  ];
}
