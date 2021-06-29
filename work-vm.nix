{ ... }:
{
  wk = {
    font.base-size = 14;
    python.enable = true;
    gui = {
      enable = true;
      outputs.primary = "HDMI-A-1";
      session_cmds = ''
        export WLR_NO_HARDWARE_CURSORS=1
      '';
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
