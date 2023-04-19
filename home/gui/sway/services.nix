{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  fd = "${pkgs.fd}/bin/fd";
  wlrctl = "${pkgs.wlrctl}/bin/wlrctl";
  bash = "${pkgs.bash}/bin/bash";

  swaymsg = "${pkgs.sway}/bin/swaymsg";
in
{
  systemd.user.targets.screen-on = {
    Unit = {
      Description = "Screen powered on target";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  systemd.user.services = {
    kanshi = {
      Unit = {
        Description = "Display output dynamic configuration for Sway";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.kanshi}/bin/kanshi";
      };
    };

    power-screen = {
      Unit = {
        Description = "Activate power to screen in sway";
        BindsTo = [ "screen-on.target" ];
        After = [ "screen-on.target" ];
      };
      Install = { WantedBy = [ "screen-on.target" ]; };
      Service = {
        Type = "oneshot";
        ExecStart = "${swaymsg} \"output * power on\"";
        ExecStop = "${swaymsg} \"output * power off\"";
        RemainAfterExit = "yes";
      };
    };

    waybar = {
      Unit = {
        Description = "Customizable bar for wayland";
        BindsTo = [ "screen-on.target" ];
        After = [ "screen-on.target" ];
      };
      Install = { WantedBy = [ "screen-on.target" ]; };
      Service = {
        Type = "dbus";
        ExecStart = "${config.programs.waybar.package}/bin/waybar";
        BusName = "fr.arouillard.waybar";
        Restart = "always";
        RestartSec = "1sec";
      };
    };
  } // lib.optionalAttrs cfg.random-wallpapers.enable {

    set-random-background = {
      Unit = {
        Description = "Set a random background for Sway";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = "${bash} -c '! ${wlrctl} toplevel find state:fullscreen state:active'";
        ExecStart = ''
          ${swaymsg} "output '*' \
            bg $(${fd} . -e png -e jpg ${cfg.random-wallpapers.directory} | shuf -n 1) fill"
        '';
        Type = "oneshot";
      };
    };
  } // lib.optionalAttrs cfg.app-indicators.network-manager {
    networkmanager-applet = {
      Unit = {
        Description = "Network Manager Tray Applet";
        BindsTo = [ "waybar.service" ];
        After = [ "waybar.service" ];
      };
      Install = {
        WantedBy = [ "waybar.service" ];
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      };
    };
  } // lib.optionalAttrs cfg.app-indicators.pulse-audio {
    pulseaudio-systray = {

      Unit = {
        Description = "PulseAudio Tray Applet";
        BindsTo = [ "waybar.service" ];
        After = [ "waybar.service" ];
      };
      Install = {
        WantedBy = [ "waybar.service" ];
      };
      Service = {
        ExecStart = "${pkgs.pasystray}/bin/pasystray";
      };
    };
  };

  systemd.user.timers = { } // lib.optionalAttrs cfg.random-wallpapers.enable {
    set-random-background = {
      Unit = {
        Description = "Set a random background for Sway";
        PartOf = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Timer = {
        OnUnitActiveSec = cfg.random-wallpapers.switch-interval;
      };
    };
  };
} 

