{ pkgs, ... }:
{
  home.file = {
    ".inputrc".source = ./inputrc;
  };
}
