{ config, lib, pkgs, ... }:

let
  cfg = config.wk.gui.idle;
  lock-cmd = "${pkgs.swaylock}/bin/swaylock -f";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  config = lib.mkIf
    (builtins.any (x: x.enable) [
      cfg.lock
      cfg.suspend
      cfg.screen-off
    ])
    {
      services.swayidle = {
        enable = true;
        systemdTarget = "sway-session.target";
        timeouts = lib.lists.optional cfg.screen-off.enable
          {
            timeout = cfg.screen-off.timeout;
            command = "${systemctl} --user start screen-off.target";
            resumeCommand = "${systemctl} --user start screen-on.target";
          } ++ lib.lists.optional cfg.suspend.enable {
          timeout = cfg.suspend.timeout;
          command = "${systemctl} suspend";
        } ++ lib.lists.optional (cfg.lock.enable && !cfg.suspend.enable) {
          timeout = cfg.lock.timeout;
          command = lock-cmd;
        };
      };

      services.swayidle.events = lib.mkIf cfg.lock.enable [
        {
          event = "lock";
          command = lock-cmd;
        }
        {
          event = "before-sleep";
          command = lock-cmd;
        }
      ];

      xdg.configFile = lib.mkIf cfg.lock.enable
        {
          "swaylock/config".text = ''
            ignore-empty-password
            image=${cfg.lock.background}
            scaling=fill
          '';
        };

      systemd.user.services.swayidle.Unit = {
        PartOf = lib.mkForce [ "sway-session.target" ];
        After = [ "sway-session.target" ];
      };
    };

}
