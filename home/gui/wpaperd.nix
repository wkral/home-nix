{ config, lib, pkgs, ... }:
let cfg = config.wk.gui.wallpapers;
in
{
  config = lib.mkIf cfg.enable {

    xdg.configFile."wpaperd/wallpaper.toml".text = ''
      [default]
      path = "${cfg.directory}"
      duration = "${cfg.interval}"
      sorting = "random"
    '';

    systemd.user.services.wpaperd = {
      Unit = {
        Description = "minimal wallpaper daemon for Wayland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wpaperd}/bin/wpaperd -d";
        Type = "forking";
      };
    };
  };
}
