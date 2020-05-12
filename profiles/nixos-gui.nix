{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ./sway.nix
    ../modules/alacritty
  ];

  options.gui = {
    base-font-size = mkOption {
      type = types.int;
      default = 9;
      example = 14;
      description = "Base font size for GUI layout";
    };
    outputs = {
      primary = mkOption {
        type = types.str;
        default = "eDP-1";
        example = "HDMI-A-1";
        description = "Primary display source";
      };
      secondary = mkOption {
        type = types.str;
        default = "HDMI-A-1";
        example = "eDP-1";
        description = "Secondary display source";
      };
    };
    idle = {
      screen-poweroff = mkOption {
        type = types.int;
        default = 540;
        example = 1200;
        description = "idle time in seconds until screen poweroff";
      };
      lock = mkOption {
        type = types.int;
        default = 600;
        example = 3600;
        description = "idle time in seconds until screen lock is started";
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      #gui tools
      xdg_utils
      xorg.xrdb
      evince # pdf viewer
      firefox-wayland
      gnome3.nautilus # file manager
      gnome3.dconf-editor
      libreoffice #office
      zathura # pdf viewer
      wireshark
      gnome3.gnome-tweak-tool
      networkmanagerapplet
      font-manager
      zbar
      imv
      gnome3.eog
      pavucontrol
      alsaUtils
      pinentry_gnome
    ];

    home.sessionVariables = {
      BROWSER = "firefox";
    };

    home.file.".Xresources".text = ''
      Xcursor.theme=Bibata_Ice
    '';
  };
}
