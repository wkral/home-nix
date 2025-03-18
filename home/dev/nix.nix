{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixfmt-rfc-style
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
