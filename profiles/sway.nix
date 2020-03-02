{pkgs, ...}:
{
  imports = [
    ../modules/sway
    ../modules/swaylock
    ../modules/waybar
    ../modules/wofi
    ../modules/kanshi
  ];
  home.packages = with pkgs; [
    xwayland
    grim          # img screencap
    slurp         # img selection tool
    mako          # notification daemon
    # wlstream      # video screencap
    swaybg
    swayidle
    wl-clipboard

    libsForQt5.qtstyleplugins
    libsForQt5.qtstyleplugin-kvantum
    arc-icon-theme
    arc-theme
    bibata-cursors
    gnome-themes-extra
    gsettings-desktop-schemas
  ];
}
