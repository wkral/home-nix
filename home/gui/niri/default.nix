{ config, lib, ... }:
{

  options.wk.gui.niri = {
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        workspace "Work" {
            open-on-output "DP-7"
        }
      '';
    };
  };
  imports = [
    ./services.nix
  ];
  config = {
    xdg.configFile."niri/config.kdl".text =
      (lib.strings.fileContents ./config.kdl) + config.wk.gui.niri.extraConfig;
  };
}
