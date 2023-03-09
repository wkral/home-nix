{ pkgs, lib, config, ... }:
let
  font-base = toString config.wk.gui.font.base-size;
in
{
  services.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "Noto Sans Light " + font-base;
    defaultTimeout = 10000;
    backgroundColor = "#1d1f21e6";
    borderColor = "#3d3f41e6";
    borderRadius = 5;
    textColor = "#eeeeeeff";
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "Lightweight Wayland notification daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      ExecStart = "${pkgs.mako}/bin//mako";
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecReload = "${pkgs.mako}/bin/makoctl reload";
    };
  };
}
