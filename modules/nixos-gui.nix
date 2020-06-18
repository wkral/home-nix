{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wk.gui;
  font-base-size = config.wk.font.base-size;
  font-base = toString font-base-size;
  font-up = toString (font-base-size + 1);
  font-down = toString (font-base-size - 1);
in
{
  options.wk.gui = {
    enable = mkEnableOption "configured Sway GUI";
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

  imports = [
    ../config/alacritty.nix
    ../config/sway
    ../config/waybar
    ../config/wofi
  ];

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        pass = super.pass.override { waylandSupport = true; };
        waybar = super.waybar.override { pulseSupport = true; };
      })
    ];

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

      wk.quickcmd

      waybar
      kanshi
      xwayland
      grim # img screencap
      slurp # img selection tool
      mako # notification daemon
      # wlstream      # video screencap
      swaybg
      swayidle
      swaylock
      wl-clipboard

      #wofi
      wofi
      hicolor-icon-theme
      gnome3.adwaita-icon-theme

      mpv

      libsForQt5.qtstyleplugins
      libsForQt5.qtstyleplugin-kvantum

      # Theming
      matcha-gtk-theme
      arc-icon-theme
      bibata-cursors
      gnome-themes-extra
      gsettings-desktop-schemas
    ];

    programs.alacritty.enable = true;

    home.sessionVariables = {
      BROWSER = "firefox";
    };

    home.file.".Xresources".text = ''
      Xcursor.theme=Bibata_Ice
    '';

    xdg.configFile = {
      "kanshi/config".source = ../config/kanshi.conf;
    };

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
        font-name = "Noto Sans " + font-base;
        document-font-name = "Noto Sans Light " + font-base;
        monospace-font-name = "Noto Sans Mono Medium Semi-Condensed " + font-down;

      };
      "org/gnome/desktop/wm/preferences" = {
        titlebar-font = "Noto Sans Semi-Bold Condensed " + font-up;
      };
    };

    programs.mako = {
      enable = true;
      font = "Noto Sans Light " + font-base;
      defaultTimeout = 10000;
      backgroundColor = "#1d1f21e6";
      borderColor = "#3d3f41e6";
      borderRadius = 5;
      textColor = "#eeeeeeff";
    };
  };
}