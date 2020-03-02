{ pkgs, ... }:
{
  home.packages = [
    pkgs.wofi
    pkgs.hicolor-icon-theme
  ];
  xdg.configFile."wofi/config".text = ''
    width=600
    lines=7
  '';
  xdg.configFile."wofi/style.css".source = ./style.css;
}
