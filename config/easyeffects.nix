{ pkgs, ... }:
let
  package = pkgs.easyeffects;
in
{
  home.packages = [ package pkgs.at-spi2-core ];

  # Will need to add `services.dbus.packages = with pkgs; [ gnome3.dconf ];`
  # to /etc/nixos/configuration.nix for daemon to work correctly

  systemd.user.services.easyeffects = {
    Unit = {
      Description = "Easyeeffects daemon";
      Requires = [ "dbus.service" ];
      After = [ "graphical-session-pre.target" "pipewire.service" ];
      PartOf = [ "graphical-session.target" "pipewire.service" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      ExecStart =
        "${package}/bin/easyeffects --gapplication-service";
      ExecStop = "${package}/bin/easyeffects --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

}
