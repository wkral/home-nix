{ config, ... }:
let
  ids = import ../ids.nix;
in
{
  services.syncthing = {
    enable = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    user = "wkral";
    group = "users";
    dataDir = "/home/wkral/.local/state/syncthing/";
    openDefaultPorts = true;
    settings = {
      devices = {
        livingroom.id = ids.livingroom.syncthing;
        phone.id = ids.phone.syncthing;
      };
      folders = {
        "wallpapers" = {
          path = "/home/wkral/wallpapers";
          id = "wallpapers";
          devices = [ "livingroom" ];
        };
        "projects" = {
          path = "/home/wkral/projects";
          id = "projects";
          devices = [ "livingroom" ];
        };
        "music" = {
          path = "/home/wkral/music";
          id = "music";
          devices = [ "livingroom" ];
        };
        "pictures" = {
          path = "/home/wkral/pictures";
          id = "pictures";
          devices = [ "livingroom" ];
        };
        "phone" = {
          path = "/home/wkral/phone";
          id = "phone";
          devices = [
            "phone"
            "livingroom"
          ];
        };
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
