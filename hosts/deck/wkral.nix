{ ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/music.nix
    ../../home/gui/signal.nix
  ];
  wk = {
    gui = {
      enable = true;
      font.base-size = 14;
      outputs.primary = "eDP-1";
      app-indicators = {
        network-manager = true;
      };
    };
  };
  home.stateVersion = "23.05";
}
