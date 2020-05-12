{ config, lib, pkgs, ... }:
with lib;
let
  font-base = config.profiles.gui.base-font-size;
  font-size = toString font-base;
  font-up = toString (font-base + 1);
  font-down = toString (font-base - 1);
in
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

      matcha-gtk-theme
      arc-icon-theme
      bibata-cursors
      gnome-themes-extra
      gsettings-desktop-schemas
    ];

    gtk = {
      theme = {
        package = pkgs.matcha-gtk-theme;
        name = "Matcha-dark-azul";
      };
      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };
      gtk3.extraConfig = {
        gtk-cursor-theme-name = "Bibata_Ice";
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Noto Sans " + font-size;
        document-font-name = "Noto Sans Light " + font-size;
        monospace-font-name = "Noto Sans Mono Medium Semi-Condensed " + font-down;

      };
      "org/gnome/desktop/wm/preferences" = {
        titlebar-font = "Noto Sans Semi-Bold Condensed " + font-up;
      };
    };

    programs.mako = {
      enable = true;
      font = "Noto Sans Light " + font-size;
      defaultTimeout = 10000;
      backgroundColor = "#1d1f21e6";
      borderColor = "#3d3f41e6";
      borderRadius = 5;
      textColor = "#eeeeeeff";
    };
  };
}
