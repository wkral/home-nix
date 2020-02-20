{ pkgs, ... }:
{
  home.packages = [
    pkgs.swaylock
  ];

  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    image=$HOME/.config/wallpapers/12883713_1600x1200.jpg
    scaling=fill
  '';

}
