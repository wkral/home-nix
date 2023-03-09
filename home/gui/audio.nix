{ pkgs, ... }:
let
  easyfx = pkgs.easyeffects;
in
{
  home.packages = [ easyfx pkgs.at-spi2-core pkgs.pulseaudio ];

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
        "${easyfx}/bin/easyeffects --gapplication-service";
      ExecStop = "${easyfx}/bin/easyeffects --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  systemd.user.services.disable-auto-mute = {
    Unit = {
      Description = "Disable auto-mute so speakers can work with headphones plugged in";
      After = [ "graphical-session-pre.target" "pipewire.service" ];
      PartOf = [ "graphical-session.target" "pipewire.service" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.alsa-utils}/bin/amixer -c Generic sset 'Auto-Mute Mode' Disabled";
      Type = "oneshot";
    };
  };

}
