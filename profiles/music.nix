{ config, pkgs, ... }:
let
  scripts = import ../scripts {
    inherit pkgs;
    inherit builtins;
  };
in
{
  home.packages = with pkgs; [
    lollypop
    id3v2

    scripts.headphones
    scripts.speakers
  ];
}
