{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.wk.gui;
  font-base = toString cfg.font.base-size;
  font-up = toString (cfg.font.base-size + 1);
  font-down = toString (cfg.font.base-size - 1);
in
{
  options.wk.gui = {
    enable = lib.mkEnableOption "configured niri GUI";
    backlight-control.enable = lib.mkEnableOption "Enable controlls for screen backlight";
    font = {
      base-size = lib.mkOption {
        type = lib.types.int;
        default = 9;
        example = 14;
        description = "Base font size for GUI layout";
      };
    };
    idle = {
      lock = {
        enable = lib.mkEnableOption "Screen locking when idle";
        timeout = lib.mkOption {
          type = lib.types.int;
          default = 720;
          example = 3600;
          description = "Idle time in seconds until screen lock is started";
        };
        background = lib.mkOption {
          type = lib.types.path;
          default = "${config.home.homeDirectory}/wallpapers/lock.jpg";
          example = "~/$HOME/background.png";
          description = "path to an image file to use as lock backgroun";
        };
      };
      suspend = {
        enable = lib.mkEnableOption "Suspend when idle";
        timeout = lib.mkOption {
          type = lib.types.int;
          default = 720;
          example = 3600;
          description = "Idle time in seconds until system is suspended";
        };
      };
      screen-off = {
        enable = lib.mkEnableOption "Power off screen when idle";
        timeout = lib.mkOption {
          type = lib.types.int;
          default = 600;
          example = 1200;
          description = "Idle time in seconds until screen poweroff";
        };
      };
    };
    wallpapers = {
      enable = lib.mkEnableOption "Random wallpaper switching";
      directory = lib.mkOption {
        type = lib.types.path;
        default = "${config.home.homeDirectory}/wallpapers/";
        example = "~/wallpapers/";
        description = "Directory with png and jpg images to be selected from";
      };
      interval = lib.mkOption {
        type = lib.types.str;
        default = "30m";
        example = "1h";
        description = "How long to wait to switch";
      };
    };
    tray = {
      network-manager = lib.mkEnableOption "Network Manager Tray Applet";
      battery = lib.mkEnableOption "Waybar battery indicator";
    };
  };

  imports = [
    inputs.wayland-pipewire-idle-inhibit.homeModules.default
    ./alacritty.nix
    ./niri
    ./mako.nix
    ./waybar
    ./wofi
    ./wpaperd.nix
    ./idle.nix
  ];

  config = {

    home.packages = with pkgs; [
      firefox-wayland
      nautilus # file manager
      dconf-editor
      wireshark
      networkmanagerapplet
      font-manager
      zbar
      imv
      pavucontrol
      alsa-utils
      pinentry-gnome3
      xdg-utils

      wk.quickcmd

      xwayland
      grim # img screencap
      slurp # img selection tool
      mako # notification daemon
      # wlstream      # video screencap
      swaylock
      wl-clipboard
      brightnessctl

      #wofi
      wofi
      hicolor-icon-theme
      adwaita-icon-theme

      libsForQt5.qtstyleplugins
      libsForQt5.qtstyleplugin-kvantum

      # Theming
      gnome-themes-extra
      gsettings-desktop-schemas
    ];

    #wayland.windowManager.sway.enable = true;

    services.kanshi = {
      enable = true;
      systemdTarget = "niri.service";
    };

    systemd.user.startServices = true;

    programs = {
      mpv = {
        enable = true;
        config = {
          cache = "yes";
          cache-secs = 30;
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

    xdg.configFile = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };

    home.sessionVariables = {
      BROWSER = "firefox";
      NIXOS_OZONE_WL = 1;
    };

    home.pointerCursor = {
      package = pkgs.simp1e-cursors;
      gtk.enable = true;
      name = "Simp1e-Breeze";
      size = 24;
    };

    home.file.".Xresources".text = ''
      Xcursor.theme=Simp1e-Breeze
      Xcursor.size=24
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
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Noto Sans " + font-base;
        document-font-name = "Noto Sans Light " + font-base;
        monospace-font-name = "Noto Sans Mono Medium Semi-Condensed " + font-down;
        gtk-theme = "Dracula";
        cursor-theme = "Simp1e-Breeze";
        icon-theme = "Tela-circle-dracula-dark";

      };
      "org/gnome/desktop/wm/preferences" = {
        titlebar-font = "Noto Sans Semi-Bold Condensed " + font-up;
      };
    };
  };

}
