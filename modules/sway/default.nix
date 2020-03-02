{pkgs, ...}:
let
  bg-source = builtins.readFile ./random-hourly-bg;
  random-hourly-bg = pkgs.writeShellScript "random-hourly-bg" bg-source;
  waybar = pkgs.waybar.override { pulseSupport = true; };
in
{

  xdg.configFile."sway/config".source = ./config;
  xdg.configFile."sway/config.d/11-workspaces".source = ./workspaces;
  xdg.configFile."sway/config.d/12-execs".text = ''
    exec ${pkgs.swayidle}/bin/swayidle \
        timeout 600 'swaylock' \
        timeout 565 'swaymsg "output * dpms off"' \
             resume 'swaymsg "output * dpms on"'

    exec ${pkgs.kanshi}/bin/kanshi

    exec_always ${random-hourly-bg}
  '';

  xdg.configFile."sway/config.d/13-bar".text = ''
    bar {
        height 19
        position top
        swaybar_command ${waybar}/bin/waybar
    }
  '';

  xdg.configFile."sway/config.d/14-style".source = ./style;
  xdg.configFile."sway/config.d/15-inputs".source = ./inputs;
  xdg.configFile."sway/config.d/16-audio-controls".source = ./audio-controls;

}
