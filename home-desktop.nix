{ ... }:
{
  wk = {
    font.base-size = 14;
    gui = {
      enable = true;
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
        pulse-audio = true;
      };
    };
    games.enable = true;
    music.enable = true;
    mkpdf.enable = true;
    signal.enable = true;
    cad.enable = true;
    zoom.enable = true;
    python.enable = true;
    rust.enable = true;

    nix-dev = {
      enable = true;
      enableLorri = true;
    };
  };

  imports = [
    ./base-profile.nix
  ];
}
