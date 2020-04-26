{ config, pkgs, ... }:
{

  imports = [
    ../modules/clojure
  ];

  home.packages = [
    pkgs.openscad
  ];

}
