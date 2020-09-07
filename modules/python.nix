{ config, lib, pkgs, ... }:
let
  cfg = config.wk.python;
  py = pkgs.python3;
  tools = py-pkgs:
    with py-pkgs; [
      flake8
      isort
    ];
  python-dev-tools = py.withPackages tools;
in
with lib;
{
  options.wk.python.enable = mkEnableOption "Python dev tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python-dev-tools
    ];

    wk.vim.ale-fixers = {
      python = [ "isort" ];
    };
  };
}
