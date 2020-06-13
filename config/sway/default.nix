{ config, pkgs, ... }:
let
  cfg = config.wk.gui;
  font-size = config.wk.font.base-size;
in
with pkgs; {

  xdg.configFile."sway/config".source = ./config;
  xdg.configFile."sway/config.d/11-menu".text = ''
    set $menu ${wofi}/bin/wofi --show drun
    bindsym $mod+d exec $menu
    bindsym $mod+grave exec ${wk.quickcmd}/bin/quickcmd
  '';
  xdg.configFile."sway/config.d/12-terminal".text = ''
    set $term ${alacritty}/bin/alacritty
    bindsym $mod+Return exec $term
  '';
  xdg.configFile."sway/config.d/13-workspaces".source = ./workspaces;
  xdg.configFile."sway/config.d/14-outputs".text = ''
    workspace $wk1 output ${cfg.outputs.primary}
    workspace $wk2 output ${cfg.outputs.primary}
    workspace $wk3 output ${cfg.outputs.primary}
    workspace $wk4 output ${cfg.outputs.primary}
    workspace $wk5 output ${cfg.outputs.primary}
    workspace $wk6 output ${cfg.outputs.primary}
    workspace $wk7 output ${cfg.outputs.primary}
    workspace $wk8 output ${cfg.outputs.secondary}
    workspace $wk9 output ${cfg.outputs.secondary}
    workspace $wk0 output ${cfg.outputs.secondary}
  '';
  xdg.configFile."sway/config.d/15-execs".text = ''
    exec ${swayidle}/bin/swayidle \
        timeout ${toString cfg.idle.lock} 'swaylock' \
        timeout ${toString cfg.idle.screen-poweroff} \
            'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"'

    exec ${networkmanagerapplet}/bin/nm-applet --indicator
    exec ${pasystray}/bin/pasystray

    exec ${kanshi}/bin/kanshi

    exec_always ${wk.random-hourly-bg}
  '';

  xdg.configFile."sway/config.d/16-bar".text = ''
    bar {
        position top
        swaybar_command ${waybar}/bin/waybar
    }
  '';

  xdg.configFile."sway/config.d/17-font".text = ''
    font Noto Sans ${toString font-size}
  '';
  xdg.configFile."sway/config.d/18-style".source = ./style;
  xdg.configFile."sway/config.d/19-inputs".source = ./inputs;
  xdg.configFile."sway/config.d/20-audio-controls".source = ./audio-controls;
  xdg.configFile."sway/config.d/21-xcursor".text = ''
    seat seat0 xcursor_theme Bibata_Ice
  '';

  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    image=$HOME/.config/swaylock/background.jpg
    scaling=fill
  '';
}
