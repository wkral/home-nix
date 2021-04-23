{ ... }:
{
  wk = {
    font.base-size = 14;
    python.enable = true;
    gui = {
      enable = true;
      outputs.primary = "HDMI-A-1";
    };
    work.enable = true;
  };

  imports = [
    ./base-profile.nix
  ];
}
