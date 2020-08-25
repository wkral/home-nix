{ config, lib, pkgs, ... }:
let
  cfg = config.wk.gui;
  mkUnit = part-of: wanted-by: description: unitFn: input: {
    Unit = {
      Description = description;
      PartOf = part-of;
    };
    Install = { WantedBy = [ wanted-by ]; };
  } // (unitFn input);

  service = cmd: { Service = { ExecStart = cmd; }; };
  oneshot = cmd: { Service = { Type = "oneshot"; ExecStart = cmd; }; };
  timer = duration: { Timer = { OnUnitActiveSec = duration; }; };

  swayUnit = mkUnit "graphical-session.target" "sway-session.target";
  waybarUnit = mkUnit "waybar.service" "waybar.service" ;

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
      set-random-background = swayUnit "Set a random background for Sway"
        oneshot ''
        ${swaymsg} "output '*' \
          bg $(${fd} . -e png -e jpg ${wallpapers} | shuf -n 1) fill"
      '';
      swayidle = swayUnit "Lock screen when idle" service ''
        ${swayidle} \
            timeout ${toString cfg.idle.lock} '${swaylock}' \
            timeout ${toString cfg.idle.screen-poweroff} \
               'systemctl --user stop screen-powered.target; \
                ${swaymsg} "output * dpms off"' \
               resume '${swaymsg} "output * dpms on"; \
                       systemctl --user start screen-powered.target'
      '';
      kanshi = swayUnit "Display output dynamic configuration for Sway"
        service "${pkgs.kanshi}/bin/kanshi";
      nm-applet = waybarUnit "Network Manager Tray Applet"
        service "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      pasystray = waybarUnit "PulseAudio Tray Applet"
        service "${pkgs.pasystray}/bin/pasystray";
    };
    timers = {
      set-random-background = swayUnit "Set a random background for Sway"
        timer "1h";
    };
  };
}
