{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.wk.nix-dev;
in
{
  options.wk.nix-dev = {
    enable = mkEnableOption "Nix development";
    enableLorri = mkEnableOption "lorri service";
  };

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.nixpkgs-fmt
      pkgs.nixpkgs-review
      pkgs.nix-update
      pkgs.niv
      pkgs.rnix-lsp
    ];

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    services.lorri.enable = cfg.enableLorri;

    wk.vim.ale-fixers.nix = [ "nixpkgs-fmt" ];
  };
}
