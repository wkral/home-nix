{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  font-size = config.wk.font.base-size;
  modifier = "Mod4";
  mkSwayService = service: {
    Unit = {
      Description = service.description;
      PartOf = "graphical-session.target";
    };
    Service = { ExecStart = service.command; };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  swayidle = "${pkgs.swayidle}/bin/swayidle";
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  fd = "${pkgs.fd}/bin/fd";
  inherit (config.xdg) configHome;
  wallpapers = "${configHome}/wallpapers";

  pactl = "${pkgs.pulseaudio}/bin/pactl";
in
{
  wayland.windowManager.sway = {
    config = {
      modifier = modifier;
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      fonts = [ "Noto Sans ${toString font-size}" ];
      keybindings = lib.mkOptionDefault {
        "${modifier}+grave" = "exec ${pkgs.wk.quickcmd}/bin/quickcmd";
        "${modifier}+x" = "splith";
        "${modifier}+Shift+e" = "exit";

        # Move workspace around with logo+alt+direction
        "${modifier}+Mod1+h" = "move workspace to output left";
        "${modifier}+Mod1+j" = "move workspace to output down";
        "${modifier}+Mod1+k" = "move workspace to output up";
        "${modifier}+Mod1+l" = "move workspace to output right";

        # audio media keys, would like to decouple from Sway
        "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
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

      seat seat0 xcursor_theme Bibata_Ice

      include config.d/*
    '';
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
  #TODO handle output direction

  systemd.user = {
    services = {
      set-random-background = {
        Unit = {
          Description = "Set a random background for Sway";
          PartOf = "graphical-session.target";
        };
        Service = {
          Type = "oneshot";
          ExecStart = ''
            ${swaymsg} "output '*' \
              bg $(${fd} . -e png -e jpg ${wallpapers} | shuf -n 1) fill"
          '';
        };
        Install = { WantedBy = [ "sway-session.target" ]; };
      };
      swayidle = mkSwayService {
        description = "Lock screen when idle";
        command = ''
          ${swayidle} \
              timeout ${toString cfg.idle.lock} '${swaylock}' \
              timeout ${toString cfg.idle.screen-poweroff} \
                 '${swaymsg} "output * dpms off"' \
                 resume '${swaymsg} "output * dpms on"'
        '';
      };
      kanshi = mkSwayService {
        description = "Display output dynamic configuration for Sway";
        command = "${pkgs.kanshi}/bin/kanshi";
      };
      netowork-manager-applet = mkSwayService {
        description = "Network Manager Tray Applet";
        command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      };
      waybar = mkSwayService {
        description = "Highly customizable Wayland bar for Sway";
        command = "${pkgs.waybar}/bin/waybar";
      };
      pasystray = mkSwayService {
        description = "PulseAudio Tray Applet";
        command = "${pkgs.pasystray}/bin/pasystray";
      };
    };
    timers.set-random-background = {
      Unit = {
        Description = "Set a random background for Sway";
        PartOf = "graphical-session.target";
      };
      Timer = {
        OnUnitActiveSec = "1h";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
  };

  #  xdg.configFile."sway/config.d/14-outputs".text = ''
  #    workspace $wk1 output ${cfg.outputs.primary}
  #    workspace $wk2 output ${cfg.outputs.primary}
  #    workspace $wk3 output ${cfg.outputs.primary}
  #    workspace $wk4 output ${cfg.outputs.primary}
  #    workspace $wk5 output ${cfg.outputs.primary}
  #    workspace $wk6 output ${cfg.outputs.primary}
  #    workspace $wk7 output ${cfg.outputs.primary}
  #    workspace $wk8 output ${cfg.outputs.secondary}
  #    workspace $wk9 output ${cfg.outputs.secondary}
  #    workspace $wk0 output ${cfg.outputs.secondary}
  #  '';

  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    image=${configHome}/swaylock/${cfg.idle.background-image}
    scaling=fill
  '';
}
