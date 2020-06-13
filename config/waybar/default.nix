{ config, pkgs, lib, ... }:
with lib;
{

  xdg.configFile."waybar/config".source = ./config.json;
  xdg.configFile."waybar/style.css".text = ''
    * {
        font-family: "Noto Sans Mono";
        font-size: ${toString config.wk.font.base-size}pt;
    }
  '' + strings.fileContents ./style.css;
}
