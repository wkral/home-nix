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
      niri.extraConfig = ''
        workspace "Surf" {
            open-on-output "DP-7"
        }

        workspace "Work" {
            open-on-output "DP-7"
        }

        workspace "Chat" {
            open-on-output "eDP-1"
        }

        spawn-at-startup "signal-desktop"
      '';
    };
  };
  home.stateVersion = "23.11";
}
