{ config, lib, pkgs, ... }:

let
  inherit (config.xdg) configHome;
  cfg = config.wk.gui.idle;
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  swaymsg = "${pkgs.sway}/bin/swaymsg";

in {
  services.swayidle = {
    enable = cfg.enable;
    timeouts = [
      {
        timeout = cfg.screen-poweroff;
        command = "${swaymsg} \"ouput * dpms off\"";
        resumeCommand = "${swaymsg} \"ouput * dpms on\"";
      }
      {
        timeout = cfg.lock;
        command = "${swaylock} -f";
      }
    ];
  };

  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    image=${configHome}/swaylock/${cfg.background-image}
    scaling=fill
  '';
}
