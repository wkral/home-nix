{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
in
{
  systemd.user.services = {
    waybar = {
      Unit = {
        Description = "Customizable bar for wayland";
        BindsTo = [ "niri.service" ];
        After = [ "niri.service" ];
      };
      Install = { WantedBy = [ "niri.service" ]; };
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
  };

} 

