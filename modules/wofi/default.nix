{ pkgs, ... }:
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
  xdg.configFile."wofi/style.css".source = ./style.css;
}
