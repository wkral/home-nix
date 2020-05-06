{ config, pkgs, lib, ... }:
with lib;
{
  home.packages = [
    (pkgs.waybar.override { pulseSupport = true; })
  ];

  xdg.configFile."waybar/config".source = ./config.json;
  xdg.configFile."waybar/style.css".text = ''
    * {
        font-family: "Noto Sans Mono";
        font-size: ${toString config.gui.base-font-size}pt;
    }
  '' + strings.fileContents ./style.css;
}
