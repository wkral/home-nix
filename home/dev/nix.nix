{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.nixpkgs-review
    pkgs.nix-update
    pkgs.niv
    pkgs.nixd
    pkgs.devenv
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    stdlib = (builtins.readFile ./direnvrc);
  };
}
