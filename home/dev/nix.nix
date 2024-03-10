{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.nixpkgs-review
    pkgs.nix-update
    pkgs.niv
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    stdlib = (builtins.readFile ./direnvrc);
  };
}
