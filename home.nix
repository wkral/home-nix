{ pkgs, ... }:

{
  imports = [
    ./profiles/work.nix
    ./profiles/wkral.nix
    ./profiles/nixos-gui.nix
    ./hardware/x1-carbon-g6/sway-input.nix
  ];
}
