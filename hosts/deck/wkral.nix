{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/music.nix
    ../../home/gui/signal.nix
    ../../home/gui/wpaperd.nix
    ./monitors.nix
  ];
  wk = {
    gui = {
      enable = true;
      idle.screen-off = {
        enable = true;
        timeout = 300;
      };
      backlight-control.enable = true;
      font.base-size = 14;
      tray = {
        network-manager = true;
        battery = true;
      };
    };
  };
  home.stateVersion = "23.05";
}
