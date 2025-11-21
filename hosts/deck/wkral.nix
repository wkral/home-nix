{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/music.nix
    ../../home/gui/signal.nix
    ./monitors.nix
    ./inputs.nix
  ];
  wk = {
    gui = {
      enable = true;
      idle = {
        suspend = {
          enable = true;
          timeout = 5400;
        };
        screen-off = {
          enable = true;
          timeout = 600;
        };
      };
      backlight-control.enable = true;
      font.base-size = 14;
      tray = {
        network-manager = true;
        battery = true;
      };
      wallpapers.enable = true;
      niri.extraConfig = ''
        workspace "Surf"

        input touch {
          map-to-output "eDP-1"
        }
      '';
    };
  };
  home.stateVersion = "23.05";
}
