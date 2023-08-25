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
    ./monitors.nix
    ./disable-auto-mute.nix
  ];
  wk = {
    gui = {
      font.base-size = 14;
      idle = {
        enable = true;
        screen-poweroff = 1200;
        lock = 3600;
        background-image = "MMvault.png";
      };
      random-wallpapers.enable = true;
      tray = {
        network-manager = true;
      };
    };
  };
  home.stateVersion = "22.11";
}
