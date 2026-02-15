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
    ../../home/gui/wayland-pipewire-idle-inhibit.nix
    ./monitors.nix
    ./disable-auto-mute.nix
  ];
  wk = {
    gui = {
      font.base-size = 14;
      idle.screen-off = {
        enable = true;
        timeout = 1200;
      };
      tray = {
        network-manager = true;
      };
      wallpapers.enable = true;
      niri.workspaces = {
        chat.enable = true;
      };
    };
  };
  home.stateVersion = "22.11";
}
