{ pkgs, ... }: {

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
