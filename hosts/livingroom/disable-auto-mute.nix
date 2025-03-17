{ pkgs, ... }: {

  systemd.user.services.disable-auto-mute = {
    Unit = {
      Description = "Disable auto-mute so speakers can work with headphones plugged in";
      After = [ "niri.service" "pipewire.service" ];
      PartOf = [ "niri.service" "pipewire.service" ];
    };

    Install = { WantedBy = [ "niri.service" ]; };
    Service = {
      ExecStart = "${pkgs.alsa-utils}/bin/amixer -c Generic sset 'Auto-Mute Mode' Disabled";
      Type = "oneshot";
    };
  };

}
