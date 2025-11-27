{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/music.nix
    ../../home/gui/mkpdf.nix
    ../../home/gui/signal.nix
    ../../home/gui/zoom.nix
    ../../home/gui/slack.nix
    ../../home/gui/wayland-pipewire-idle-inhibit.nix
    ./monitors.nix
  ];
  wk = {
    gui = {
      font.base-size = 9;
      idle = {
        suspend = {
          enable = true;
          timeout = 720;
        };
        lock.enable = true;
      };
      backlight-control.enable = true;
      tray = {
        network-manager = true;
        battery = true;
      };
      wallpapers.enable = true;
      niri.workspaces = {
        surf = {
          enable = true;
          monitor = "DP-7";
        };
        work = {
          enable = true;
          monitor = "DP-7";
        };
        chat = {
          enable = true;
          monitor = "eDP-1";
        };
      };
    };
  };
  home.stateVersion = "23.11";
}
