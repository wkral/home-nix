{ lib }:
let
  option = val: as: lib.optionalAttrs (val != null) as;
in
rec {
  mkUnit =
    { Description
    , Wants ? null
    , Requisite ? null
    , PartOf ? null
    , BindsTo ? null
    , Conflicts ? null
    , After ? null
    , Before ? null
    , WantedBy ? null
    , ConditionEnvironment ? null
    , ...
    }: {
      Unit = {
        Description = Description;
      } //
      option Wants { Wants = Wants; } //
      option Requisite { Requisite = Requisite; } //
      option PartOf { PartOf = PartOf; } //
      option BindsTo { BindsTo = BindsTo; } //
      option Conflicts { Conflicts = Conflicts; } //
      option After { After = After; } //
      option Before { Before = Before; } //
      option ConditionEnvironment {
        ConditionEnvironment = ConditionEnvironment;
      };
    } //
    option WantedBy {
      Install = { WantedBy = [ WantedBy ]; };
    };

  mkService =
    { ExecStart ? null
    , ExecStop ? null
    , ExecReload ? null
    , Environment ? null
    , Type ? null
    , BusName ? null
    , Restart ? null
    , RestartSec ? null
    , ...
    } @ options:
    mkUnit options //
    option ExecStart {
      Service = {
        ExecStart = ExecStart;
      } //
      option ExecStop { ExecStop = ExecStop; } //
      option Environment { Environment = Environment; } //
      option ExecReload { ExecReload = ExecReload; } //
      option Type { Type = Type; } //
      option BusName { BusName = BusName; } //
      option Restart { Restart = Restart; } //
      option RestartSec { RestartSec = RestartSec; };
    };

  mkTimer = { OnUnitActiveSec, ... } @ options:
    mkUnit options //
    { Timer = { OnUnitActiveSec = OnUnitActiveSec; }; };

  swayService = desc: cmd: extras: mkService
    ({
      Description = desc;
      ExecStart = cmd;
      PartOf = "graphical-session.target";
      WantedBy = "sway-session.target";
    } // extras);

  swayTimer = desc: duration: extras: mkTimer
    ({
      Description = desc;
      OnUnitActiveSec = duration;
      PartOf = "graphical-session.target";
      WantedBy = "sway-session.target";
    } // extras);
}
