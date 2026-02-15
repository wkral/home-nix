{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  font-size = cfg.font.base-size;
  modifier = "Mod4";

  wpctl = action: "exec '${pkgs.wireplumber}/bin/wpctl ${action}'";
  sysd = target: action: "exec 'systemctl --user ${action} ${target}'";
  session = sysd "graphical-session.target";
  brightnessctl = action: "exec '${pkgs.brightnessctl}/bin/brightnessctl ${action}'";
in
{
  imports = [
    ./services.nix
  ];
  wayland.windowManager.sway = {
    package = null;
    config = {
      modifier = modifier;
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 0.0 + font-size;
      };
      keybindings = lib.mkOptionDefault ({
        "${modifier}+grave" = "exec ${pkgs.wk.quickcmd}/bin/quickcmd";
        "${modifier}+x" = "splith";
        "${modifier}+Shift+c" = "${session "restart"}; reload";
        "${modifier}+Shift+e" = ''
          exec swaynag -t warning -m 'Exit sway?' \
          -b 'Logout' 'systemctl --user stop sway-session.target; swaymsg exit' \
          -b 'Suspend' 'systemctl suspend' \
          -b 'Restart' 'systemctl reboot' \
          -b 'Shutdown' 'systemctl poweroff'
        '';
        "${modifier}+Shift+p" = "exec systemctl suspend";

        # Screen shot hot keys
        "${modifier}+Print" = "exec ${pkgs.grim}/bin/grim";
        "${modifier}+Shift+Print" = ''
          exec ${pkgs.grim}/bin/grim \
          -g "$(${pkgs.slurp}/bin/slurp)"'';

        # Move workspace around with logo+alt+direction
        "${modifier}+Mod1+h" = "move workspace to output left";
        "${modifier}+Mod1+j" = "move workspace to output down";
        "${modifier}+Mod1+k" = "move workspace to output up";
        "${modifier}+Mod1+l" = "move workspace to output right";

        # audio media keys, would like to decouple from Sway
        "XF86AudioRaiseVolume" = wpctl "set-volume @DEFAULT_AUDIO_SINK@ 3%+";
        "XF86AudioLowerVolume" = wpctl "set-volume @DEFAULT_AUDIO_SINK@ 3%-";
        "XF86AudioMute" = wpctl "set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = wpctl "set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      } // lib.optionalAttrs cfg.backlight-control.enable {
        "XF86MonBrightnessUp" = brightnessctl "set +5%";
        "XF86MonBrightnessDown" = brightnessctl "set 5%-";
      });
      window.border = 0;
      window.titlebar = false;
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
      output = {
        "*" = {
          bg = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
        };
      };
      seat." * " = {
        xcursor_theme = "Simp1e-Breeze";
      };
      startup = [
        {
          command = "${pkgs.firefox}/bin/firefox";
        }
      ];
    };
    extraConfig = ''
      hide_edge_borders --i3 smart

      titlebar_border_thickness 1
      titlebar_padding 5 2

      include config.d/*
    '';
  };

}

