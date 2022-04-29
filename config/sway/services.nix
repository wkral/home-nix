{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;

  sysdLib = import ../../lib/systemd.nix { inherit lib; };
  inherit (sysdLib) mkUnit swayService swayTimer;

  fd = "${pkgs.fd}/bin/fd";

  swayidle = "${pkgs.swayidle}/bin/swayidle";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
in
{
  systemd.user = {
    services = {
      kanshi = swayService "Display output dynamic configuration for Sway"
        "${pkgs.kanshi}/bin/kanshi"
        { };
    } // lib.optionalAttrs cfg.random-wallpapers.enable {
      set-random-background = swayService "Set a random background for Sway" ''
        ${swaymsg} "output '*' \
          bg $(${fd} . -e png -e jpg ${cfg.random-wallpapers.directory} | shuf -n 1) fill"
      ''
        { Type = "oneshot"; };
    };
    timers = { } // lib.optionalAttrs cfg.random-wallpapers.enable {
      set-random-background = swayTimer "Set a random background for Sway"
        cfg.random-wallpapers.switch-interval
        { };
    };
  };
}
