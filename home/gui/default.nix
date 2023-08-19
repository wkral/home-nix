{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wk.gui;
  font-base = toString cfg.font.base-size;
  font-up = toString (cfg.font.base-size + 1);
  font-down = toString (cfg.font.base-size - 1);
in
{
  options.wk.gui = {
    enable = mkEnableOption "configured Sway GUI";
    backlight-control.enable = mkEnableOption "Enable controlls for screen backlight";
    font = {
      base-size = mkOption {
        type = types.int;
        default = 9;
        example = 14;
        description = "Base font size for GUI layout";
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
    };
  };

  imports = [
    ./alacritty.nix
    ./sway
    ./mako.nix
    ./waybar
    ./wofi
  ];

  config = {

    home.packages = with pkgs; [
      firefox-wayland
      gnome.nautilus # file manager
      gnome.dconf-editor
      wireshark
      networkmanagerapplet
      font-manager
      zbar
      imv
      pavucontrol
      alsa-utils
      pinentry-gnome
      xdg-utils

      wk.quickcmd

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
      gnome.adwaita-icon-theme

      libsForQt5.qtstyleplugins
      libsForQt5.qtstyleplugin-kvantum

      # Theming
      gnome-themes-extra
      gsettings-desktop-schemas
    ];

    wayland.windowManager.sway.enable = true;

    services.kanshi = {
      enable = true;
      systemdTarget = "sway-session.target";
    };

    systemd.user.startServices = true;

    programs = {
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
    };

    home.sessionVariables = {
      BROWSER = "firefox";
    };

    home.file.".Xresources".text = ''
      Xcursor.theme=Bibata-Modern-Ice
    '';

    gtk = {
      theme = {
        package = pkgs.dracula-theme;
        name = "Dracula";
      };
      iconTheme = {
        package = pkgs.tela-circle-icon-theme;
        name = "Tela-circle-dracula-dark";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
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
