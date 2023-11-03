{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  fd = "${pkgs.fd}/bin/fd";
  wlrctl = "${pkgs.wlrctl}/bin/wlrctl";
  bash = "${pkgs.bash}/bin/bash";

  swaymsg = "${pkgs.sway}/bin/swaymsg";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
  systemd.user.targets = {
    screen-on = {
      Unit = {
        Description = "Screen powered on target";
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
    screen-off = {
      Unit = {
        Description = "Screen powered off target";
        Conflicts = [ "screen-on.target" ];
        After = [ "screen-on.target" ];
        StopWhenUnneeded = true;
      };
    };
  };

  systemd.user.services = {
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
  } // lib.optionalAttrs cfg.tray.network-manager {
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
  } // lib.optionalAttrs cfg.backlight-control.enable {
    backlight-save-restore = {
      Unit = {
        Description = "Restore backlight to levels before powering off";
        BindsTo = [ "screen-on.target" ];
        After = [ "power-screen.service" "screen-on.target" ];
      };
      Install = { WantedBy = [ "screen-on.target" ]; };
      Service = {
        Type = "oneshot";
        ExecStart = "${brightnessctl} -r";
        ExecStop = "${brightnessctl} -s";
        ExecStopPost = "${brightnessctl} set 0";
        RemainAfterExit = "yes";
      };
    };
  };

} 

