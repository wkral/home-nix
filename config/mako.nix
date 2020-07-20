{ pkgs, config, ... }:
let
  font-base = toString config.wk.font.base-size;
  mako = pkgs.mako;
in
{
  programs.mako = {
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
      Documentation = "man:mako(1)";
      PartOf = "graphical-session.target";
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${mako}/bin//mako";
      ExecReload = "${mako}/bin/makoctl reload";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };
}
