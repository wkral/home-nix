{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  font-size = config.wk.font.base-size;
  modifier = "Mod4";
  inherit (config.xdg) configHome;

  pactl = action: "exec '${pkgs.pulseaudio}/bin/pactl ${action}'";
  sysd = target: action: "exec 'systemctl --user ${action} ${target}'";
  session = sysd "graphical-session.target";
in
{
  imports = [
    ./dropdown-term.nix
    ./idle.nix
    ./services.nix
  ];
  wayland.windowManager.sway = {
    config = {
      modifier = modifier;
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 0.0 + font-size;
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+grave" = "exec ${pkgs.wk.quickcmd}/bin/quickcmd";
        "${modifier}+x" = "splith";
        "${modifier}+Shift+c" = "${session "restart"}; reload";
        "${modifier}+Shift+e" = ''
          exec swaynag -t warning -m 'Exit sway?' \
          -b 'Logout' 'swaymsg exit' \
          -b 'Restart' 'systemctl reboot' \
          -b 'Shutdown' 'systemctl poweroff'
        '';

        # Move workspace around with logo+alt+direction
        "${modifier}+Mod1+h" = "move workspace to output left";
        "${modifier}+Mod1+j" = "move workspace to output down";
        "${modifier}+Mod1+k" = "move workspace to output up";
        "${modifier}+Mod1+l" = "move workspace to output right";

        # audio media keys, would like to decouple from Sway
        "XF86AudioRaiseVolume" = pactl "set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = pactl "set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = pactl "set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = pactl "set-source-mute @DEFAULT_SOURCE@ toggle";
      };
      window.border = 0;
      focus.followMouse = false;
      colors = {
        focused = {
          border = "#0b609ee6";
          background = "#0b609ee6";
          text = "#eeeeee";
          indicator = "";
          childBorder = "";
        };
        unfocused = {
          border = "#3d3f41e6";
          background = "#1d1f21e6";
          text = "#888888";
          indicator = "";
          childBorder = "";
        };
      };
      gaps = {
        inner = 8;
        outer = -8;
        smartGaps = true;
      };
      bars = [ ];
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          click_method = "clickfinger";
          tap = "enabled";
          drag = "disabled";
          natural_scroll = "enabled";
          middle_emulation = "disabled";
          accel_profile = "adaptive";
          drag_lock = "disabled";
          pointer_accel = "0.2";
        };
        "type:pointer" = {
          accel_profile = "adaptive";
        };
        "type:keyboard" = {
          xkb_capslock = "disabled";
          xkb_options = "caps:escape";
        };
      };
      seat."*" = {
        xcursor_theme = "Bibata-Modern-Ice";
      };
      startup = [
        {
          command = "${pkgs.firefox-wayland}/bin/firefox";
        }
      ];
    };
    extraConfig = ''
      hide_edge_borders --i3 smart

      titlebar_border_thickness 1
      titlebar_padding 5 2

      include config.d/*
    '';
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export QT_FONT_DPI=144
    '' + cfg.session_cmds;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };

}
