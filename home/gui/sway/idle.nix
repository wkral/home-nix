{ config, lib, pkgs, ... }:

let
  inherit (config.xdg) configHome;
  cfg = config.wk.gui.idle;
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = cfg.enable;
      timeouts = [
        {
          timeout = cfg.screen-poweroff;
          command = "${systemctl} --user stop screen-on.target";
          resumeCommand = "${systemctl} --user start screen-on.target";
        }
#        {
#          timeout = cfg.lock;
#          command = "${swaylock} -f";
#        }
      ];
    };

    xdg.configFile."swaylock/config".text = ''
      ignore-empty-password
      image=${configHome}/swaylock/${cfg.background-image}
      scaling=fill
    '';
  };

}
