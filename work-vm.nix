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
        export WLR_RENDERER_ALLOW_SOFTWARE=1
      '';
    };
    git.user_email = "william.kral@netlync.com";
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
