{ pkgs, lib, config, ... }:
let
  font-base = toString config.wk.font.base-size;

  sysdLib = import ../lib/systemd.nix { inherit lib; };
  inherit (sysdLib) swayService;
in
{
  programs.mako = {
    anchor = "bottom-right";
    font = "Noto Sans Light " + font-base;
    defaultTimeout = 10000;
    backgroundColor = "#1d1f21e6";
    borderColor = "#3d3f41e6";
    borderRadius = 5;
    textColor = "#eeeeeeff";
  };

  systemd.user.services = {
    mako = swayService "Lightweight Wayland notification daemon"
      "${pkgs.mako}/bin//mako"
      {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
      };
  };
}
