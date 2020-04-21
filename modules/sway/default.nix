{ config, pkgs, ... }:
let
  bg-source = builtins.readFile ./random-hourly-bg;
  random-hourly-bg = pkgs.writeShellScript "random-hourly-bg" bg-source;
  waybar = pkgs.waybar.override { pulseSupport = true; };
in
{

  xdg.configFile."sway/config".source = ./config;
  xdg.configFile."sway/config.d/11-menu".text = ''
    set $menu ${pkgs.wofi}/bin/wofi --show drun
    bindsym $mod+d exec $menu
  '';
  xdg.configFile."sway/config.d/12-terminal".text = ''
    set $term ${pkgs.alacritty}/bin/alacritty
    bindsym $mod+Return exec $term
  '';
  xdg.configFile."sway/config.d/13-workspaces".source = ./workspaces;
  xdg.configFile."sway/config.d/14-execs".text = ''
    exec ${pkgs.swayidle}/bin/swayidle \
        timeout 600 'swaylock' \
        timeout 565 'swaymsg "output * dpms off"' \
             resume 'swaymsg "output * dpms on"'

    exec ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
    exec ${pkgs.pasystray}/bin/pasystray

    exec ${pkgs.kanshi}/bin/kanshi

    exec_always ${random-hourly-bg}
  '';

  xdg.configFile."sway/config.d/15-bar".text = ''
    bar {
        position top
        swaybar_command ${waybar}/bin/waybar
    }
  '';

  xdg.configFile."sway/config.d/16-font".text = ''
    font Noto Sans ${toString config.profiles.gui.base-font-size}
  '';
  xdg.configFile."sway/config.d/17-style".source = ./style;
  xdg.configFile."sway/config.d/18-inputs".source = ./inputs;
  xdg.configFile."sway/config.d/19-audio-controls".source = ./audio-controls;
  xdg.configFile."sway/config.d/20-xcursor".text = ''
    seat seat0 xcursor_theme Bibata_Ice
  '';

}
