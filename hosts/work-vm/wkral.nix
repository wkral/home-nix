{ pkgs, ... }:
{
  imports = [
    ../../home/console
    ../../home/gui
    ../../home/gui/mkpdf.nix
    ../../home/gui/zoom.nix
  ];
  wk = {
    gui = {
      enable = true;
      font.base-size = 14;
      outputs.primary = "HDMI-A-1";
      session_cmds = ''
        export WLR_NO_HARDWARE_CURSORS=1
      '';
    };
    git.user_email = "william.kral@netlync.com";
  };
  home.packages = with pkgs; [
    teams

    pandoc
    graphviz
    plantuml
    librsvg
    wk.texlive
  ];
  home.stateVersion = "22.11";
}
