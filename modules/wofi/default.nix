{ config, lib, pkgs, ... }:
with lib;
{
  home.packages = [
    pkgs.wofi
    pkgs.hicolor-icon-theme
    pkgs.gnome3.adwaita-icon-theme
  ];
  xdg.configFile."wofi/config".text = ''
    width=600
    lines=7
    allow_images=true
  '';
  xdg.configFile."wofi/style.css".text = ''
    * {
        font-family: "Noto Sans SemiBold";
        font-size: ${toString (config.profiles.gui.base-font-size + 1)}pt;
    }
  '' + strings.fileContents ./style.css;
}
