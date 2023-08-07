{ pkgs, ... }:
let
  easyfx = pkgs.easyeffects;
in
{
  home.packages = [ easyfx pkgs.at-spi2-core pkgs.pulseaudio ];

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
        "${easyfx}/bin/easyeffects --gapplication-service";
      ExecStop = "${easyfx}/bin/easyeffects --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

}
