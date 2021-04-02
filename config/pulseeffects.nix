{ pkgs, ... }:
let
  package = pkgs.pulseeffects-legacy;
in
{
  home.packages = [ package pkgs.at-spi2-core ];

  # Will need to add `services.dbus.packages = with pkgs; [ gnome3.dconf ];`
  # to /etc/nixos/configuration.nix for daemon to work correctly

  systemd.user.services.pulseeffects = {
    Unit = {
      Description = "Pulseeffects daemon";
      Requires = [ "dbus.service" ];
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" "pulseaudio.service" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      ExecStart =
        "${package}/bin/pulseeffects --gapplication-service";
      ExecStop = "${package}/bin/pulseeffects --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

}
