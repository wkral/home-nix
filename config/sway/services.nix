{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;

  sysdLib = import ../../lib/systemd.nix { inherit lib; };
  inherit (sysdLib) mkUnit swayService swayTimer;

  fd = "${pkgs.fd}/bin/fd";

  inherit (config.xdg) configHome;
  wallpapers = "${configHome}/wallpapers";

  swaylock = "${pkgs.swaylock}/bin/swaylock";
  swayidle = "${pkgs.swayidle}/bin/swayidle";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
in
{
  systemd.user = {
    services = {
      set-random-background = swayService "Set a random background for Sway" ''
        ${swaymsg} "output '*' \
          bg $(${fd} . -e png -e jpg ${wallpapers} | shuf -n 1) fill"
      ''
        { Type = "oneshot"; };
      kanshi = swayService "Display output dynamic configuration for Sway"
        "${pkgs.kanshi}/bin/kanshi"
        { };
    } // lib.optionalAttrs cfg.idle.enable {
      swayidle = swayService "Lock screen when idle" ''
        ${swayidle} \
            timeout ${toString cfg.idle.lock} '${swaylock}' \
            timeout ${toString cfg.idle.screen-poweroff} \
               'systemctl --user stop screen-powered.target; \
                ${swaymsg} "output * dpms off"' \
               resume '${swaymsg} "output * dpms on"; \
                       systemctl --user start screen-powered.target'
      ''
        { };
    };
    timers = {
      set-random-background = swayTimer "Set a random background for Sway" "1h"
        { };
    };
    targets = {
      screen-powered = mkUnit {
        Description = "Screen is powered";
        BindsTo = "sway-session.target";
        PartOf = "sway-session.target";
        WantedBy = "sway-session.target";
      };
    };
  };
}
