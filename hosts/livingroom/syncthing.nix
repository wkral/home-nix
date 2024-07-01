{ config, ... }:
let ids = import ../ids.nix;
in
{
  services.syncthing = {
    enable = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    openDefaultPorts = true;
    settings = {
      devices = {
        framework = {
          id = ids.framework.syncthing;
        };
      };
      folders = {
        "/home/wkral/wallpapers" = {
          id = "wallpapers";
          devices = [ "framework" ];
        };
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

}
