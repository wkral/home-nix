{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
  ];
  users.extraGroups.docker.members = [ "wkral" ];
}
