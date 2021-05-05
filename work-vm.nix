{ ... }:
{
  wk = {
    font.base-size = 14;
    python.enable = true;
    gui = {
      enable = true;
      outputs.primary = "HDMI-A-1";
    };
    mkpdf.enable = true;
    work.enable = true;
    zoom.enable = true;

    nix-dev = {
      enable = true;
      enableLorri = true;
    };
  };

  imports = [
    ./base-profile.nix
  ];
}
