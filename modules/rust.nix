{ config, lib, pkgs, ... }:
let
  cfg = config.wk.rust;
in
with lib;
{
  options.wk.rust.enable = mkEnableOption "Rust dev setup";

  config = mkIf cfg.enable {

    wk.vim.ale-fixers = {
      rust = [ "rustfmt" ];
    };

    wk.vim.ale-linters = {
      rust = [ "analyzer" "cargo" ];
    };
  };
}
