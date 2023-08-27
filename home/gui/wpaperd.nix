{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    wpaperd
  ];

  xdg.configFile."wpaperd/wallpaper.toml".text = ''
    [default]
    path = "/home/wkral/wallpapers/"
    duration = "30m"
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
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
      Type = "forking";
    };
  };
}
