{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
in
{
  systemd.user.targets = {
    screen-on = {
      Unit = {
        Description = "Screen powered on target";
        BindsTo = [ "niri.service" ];
        Wants = [ "niri.service" ];
        After = [ "niri.service" ];
      };
      Install = { WantedBy = [ "niri.service" ]; };
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
    xwayland-satellite = {
      Unit = {
        Description="Xwayland outside your Wayland";
        BindsTo="niri.service";
        PartOf="niri.service";
        After="niri.service";
        Requisite="niri.service";
      };
      Service = {
        Type="notify";
        NotifyAccess="all";
        ExecStart="${pkgs.xwayland-satellite}/bin/xwayland-satellite";
        StandardOutput="journal";
      };
      Install = { WantedBy=["niri.service"]; };
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

