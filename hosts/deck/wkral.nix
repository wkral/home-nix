{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/music.nix
    ../../home/gui/signal.nix
    ./monitors.nix
  ];
  wk = {
    gui = {
      enable = true;
      idle = {
        enable = true;
        screen-poweroff = 1200;
        lock = 3600;
      };
      backlight-control.enable = true;
      font.base-size = 14;
      app-indicators = {
        network-manager = true;
      };
    };
  };
  home.stateVersion = "23.05";
}
