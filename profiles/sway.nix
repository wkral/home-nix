{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ../modules/sway
    ../modules/swaylock
    ../modules/waybar
    ../modules/wofi
    ../modules/kanshi
  ];

  options.profiles.gui = {
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
  };

  config = {
    home.packages = with pkgs; [
      xwayland
      grim # img screencap
      slurp # img selection tool
      mako # notification daemon
      # wlstream      # video screencap
      swaybg
      swayidle
      wl-clipboard

      mpv

      libsForQt5.qtstyleplugins
      libsForQt5.qtstyleplugin-kvantum
      arc-icon-theme
      matcha #theme

      bibata-cursors
      gnome-themes-extra
      gsettings-desktop-schemas
    ];
  };
}
