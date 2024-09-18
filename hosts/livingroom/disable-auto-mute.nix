{ pkgs, ... }: {

  systemd.user.services.disable-auto-mute = {
    Unit = {
      Description = "Disable auto-mute so speakers can work with headphones plugged in";
      After = [ "sway-session-pre.target" "pipewire.service" ];
      PartOf = [ "sway-session.target" "pipewire.service" ];
    };

    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.alsa-utils}/bin/amixer -c Generic sset 'Auto-Mute Mode' Disabled";
      Type = "oneshot";
    };
  };

}
