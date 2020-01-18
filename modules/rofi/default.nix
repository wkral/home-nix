{ pkgs, ... }:
{
  home.packages = [
    pkgs.rofi
  ];
  xdg.configFile."rofi/config".text = ''
    rofi.theme: theme.rasi
    rofi.font: Noto Sans Mono 11
    rofi.lines: 8
    rofi.sort: true
    rofi.monitor: 0
  '';
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
}
