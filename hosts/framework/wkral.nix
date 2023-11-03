{ config, ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/games.nix
    ../../home/gui/music.nix
    ../../home/gui/mkpdf.nix
    ../../home/gui/signal.nix
    ../../home/gui/wpaperd.nix
    ../../home/gui/zoom.nix
    ./monitors.nix
  ];
  wk = {
    gui = {
      font.base-size = 9;
      idle = {
        suspend = {
          enable = true;
          timeout = 600;
        };
        lock.enable = true;
      };
      backlight-control.enable = true;
      random-wallpapers.enable = false;
      tray = {
        network-manager = true;
        battery = true;
      };
    };
  };
  home.stateVersion = "23.11";
}
