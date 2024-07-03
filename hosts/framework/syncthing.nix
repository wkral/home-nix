{ config, ... }:
let ids = import ../ids.nix;
in
{
  services.syncthing = {
    enable = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    user = "wkral";
    dataDir = "/home/wkral/.local/state/syncthing/";
    openDefaultPorts = true;
    settings = {
      devices = {
        livingroom = {
          id = ids.livingroom.syncthing;
        };
      };
      folders = {
        "/home/wkral/wallpapers" = {
          id = "wallpapers";
          devices = [ "livingroom" ];
        };
        "/home/wkral/projects" = {
          id = "projects";
          devices = [ "livingroom" ];
        };
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
