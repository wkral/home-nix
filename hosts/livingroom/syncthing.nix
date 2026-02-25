{ config, ... }:
let
  ids = import ../ids.nix;
in
{
  services.syncthing = {
    enable = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    openDefaultPorts = true;
    user = "wkral";
    group = "users";
    dataDir = "/home/wkral/.local/state/syncthing/";
    settings = {
      devices = {
        framework.id = ids.framework.syncthing;
        phone.id = ids.phone.syncthing;
      };
      folders = {
        "wallpapers" = {
          path = "/home/wkral/wallpapers";
          id = "wallpapers";
          devices = [ "framework" ];
        };
        "projects" = {
          path = "/home/wkral/projects";
          id = "projects";
          devices = [ "framework" ];
        };
        "music" = {
          path = "/home/wkral/music";
          id = "music";
          devices = [ "framework" ];
        };
        "pictures" = {
          path = "/home/wkral/pictures";
          id = "pictures";
          devices = [ "framework" ];
        };
        "phone" = {
          path = "/home/wkral/phone";
          id = "phone";
          devices = [
            "phone"
            "framework"
          ];
        };
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

}
