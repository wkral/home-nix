{ pkgs, ... }:
{
  home.packages = [
    pkgs.swaylock
  ];

  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    image=$HOME/.config/swaylock/background.jpg
    scaling=fill
  '';

}
