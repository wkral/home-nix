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
      enable = mkEnableOption "Idle screen lock/poweroff";
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
      background-image = mkOption {
        type = types.str;
        default = "background.jpg";
        example = "background.png";
        description = "Image filename found under ~/.config/swaylock/";
      };
    };
    session_cmds = mkOption {
      type = types.str;
      default = "";
      example = ''
        export WLR_NO_HARDWARE_CURSORS=1
      '';
      description = "Commands appended to sway.extraSessionCommands";
    };
    random-wallpapers = {
      enable = mkEnableOption "Random wallpaper switching";
      directory = mkOption {
        type = types.str;
        default = "${config.xdg.configHome}/wallpapers/";
        example = "~/wallpapers/";
        description = "Directory with png and jpg images to be selected from";
      };
      switch-interval = mkOption {
          type = types.str;
          default = "1h";
          example = "30m";
          description = "Systemd time interval definition";
      };
    };
    app-indicators = {
     network-manager = mkEnableOption "Network Manager Tray Applet";
     pulse-audio = mkEnableOption "PulseAudio Tray Applet";
    };
  };

  imports = [
    ../config/alacritty.nix
    ../config/easyeffects.nix
    ../config/sway
    ../config/mako.nix
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
      evince # pdf viewer
      firefox-wayland
      gnome3.nautilus # file manager
      gnome3.dconf-editor
      libreoffice #office
      wireshark
      networkmanagerapplet
      font-manager
      zbar
      imv
      gnome3.eog
      pavucontrol
      alsaUtils
      pinentry_gnome
      xdg_utils

      wk.quickcmd

      waybar
      xwayland
      grim # img screencap
      slurp # img selection tool
      mako # notification daemon
      # wlstream      # video screencap
      swaylock
      wl-clipboard

      #wofi
      wofi
      hicolor-icon-theme
      gnome3.adwaita-icon-theme

      libsForQt5.qtstyleplugins
      libsForQt5.qtstyleplugin-kvantum

      # Theming
      matcha-gtk-theme
      arc-icon-theme
      bibata-cursors
      gnome-themes-extra
      gsettings-desktop-schemas
    ];

    wayland.windowManager.sway.enable = true;

    programs = {
      alacritty.enable = true;
      mako.enable = true;
      mpv = {
        enable = true;
        config = {
          cache = "yes";
          cache-secs = 5;
        };
      };
      zathura = {
        enable = true;
        options = {
          font = "Noto Sans Mono ${font-base}";
          adjust-open = "width";
        };
      };
      waybar.enable = true;
    };

    home.sessionVariables = {
      BROWSER = "firefox";
      XDG_CURRENT_DESKTOP = "sway";
    };

    home.file.".Xresources".text = ''
      Xcursor.theme=Bibata-Modern-Ice
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
        gtk-cursor-theme-name = "Bibata-Modern-Ice";
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

  };
}
