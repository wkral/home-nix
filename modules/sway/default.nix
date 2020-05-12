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
  xdg.configFile."sway/config.d/14-outputs".text = ''
    workspace $wk1 output ${config.gui.outputs.primary}
    workspace $wk2 output ${config.gui.outputs.primary}
    workspace $wk3 output ${config.gui.outputs.primary}
    workspace $wk4 output ${config.gui.outputs.primary}
    workspace $wk5 output ${config.gui.outputs.primary}
    workspace $wk6 output ${config.gui.outputs.primary}
    workspace $wk7 output ${config.gui.outputs.primary}
    workspace $wk8 output ${config.gui.outputs.secondary}
    workspace $wk9 output ${config.gui.outputs.secondary}
    workspace $wk0 output ${config.gui.outputs.secondary}
  '';
  xdg.configFile."sway/config.d/15-execs".text = ''
    exec ${pkgs.swayidle}/bin/swayidle \
        timeout ${toString config.gui.idle.lock} 'swaylock' \
        timeout ${toString config.gui.idle.screen-poweroff} \
            'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"'

    exec ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
    exec ${pkgs.pasystray}/bin/pasystray

    exec ${pkgs.kanshi}/bin/kanshi

    exec_always ${random-hourly-bg}
  '';

  xdg.configFile."sway/config.d/16-bar".text = ''
    bar {
        position top
        swaybar_command ${waybar}/bin/waybar
    }
  '';

  xdg.configFile."sway/config.d/17-font".text = ''
    font Noto Sans ${toString config.gui.base-font-size}
  '';
  xdg.configFile."sway/config.d/18-style".source = ./style;
  xdg.configFile."sway/config.d/19-inputs".source = ./inputs;
  xdg.configFile."sway/config.d/20-audio-controls".source = ./audio-controls;
  xdg.configFile."sway/config.d/21-xcursor".text = ''
    seat seat0 xcursor_theme Bibata_Ice
  '';

}
