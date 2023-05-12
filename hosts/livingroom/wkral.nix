{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/games.nix
    ../../home/gui/music.nix
    ../../home/gui/mkpdf.nix
    ../../home/gui/signal.nix
    ../../home/gui/calibre.nix
    ../../home/gui/zoom.nix
  ];
  wk = {
    gui = {
      font.base-size = 14;
      outputs.primary = "HDMI-A-1";
      idle = {
        enable = true;
        screen-poweroff = 1200;
        lock = 3600;
        background-image = "MMvault.png";
      };
      random-wallpapers.enable = true;
      app-indicators = {
        network-manager = true;
      };
    };
  };
  home.stateVersion = "22.11";
}
