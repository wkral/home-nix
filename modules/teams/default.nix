{pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.teams
  ];
}
