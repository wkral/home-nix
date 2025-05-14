{ pkgs, config, ... }:
let
  font-base = toString config.wk.gui.font.base-size;
in
{
  services.mako = {
    enable = true;
    settings = {
      anchor = "bottom-right";
      font = "Noto Sans Light " + font-base;
      default-timeout = "10000";
      background-color = "#1d1f21e6";
      border-color = "#3d3f41e6";
      border-radius = "5";
      border-size = "1";
      text-color = "#eeeeeeff";
      width = "300";
      height = "100";
      margin = "10";
      padding = "5";
      max-visible = "5";
      max-history = "5";
      sort = "-time";
      layer = "top";
      ignore-timeout = "false";
      format = "<b>%s</b>\\n%b";
      actions = "true";
      markup = "true";
      progress-color = "over #5588AAFF";
      icons = "true";
      max-icon-size = "64";

    };
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "Lightweight Wayland notification daemon";
      PartOf = [ "niri.service" ];
      After = [ "niri.service" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Install = {
      WantedBy = [ "niri.service" ];
    };

    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecReload = "${pkgs.mako}/bin/makoctl reload";
    };
  };
}
