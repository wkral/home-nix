{ ... }:
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
      font.base-size = 11;
      idle = {
        enable = true;
        screen-poweroff = 600;
        lock = 720;
        background-image = "MMvault.png";
      };
      random-wallpapers.enable = false;
      tray = {
        network-manager = true;
      };
    };
  };
  home.stateVersion = "23.11";
}
