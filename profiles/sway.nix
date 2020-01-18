{pkgs, ...}:
{
  imports = [
    ../modules/sway
    ../modules/swaylock
    ../modules/waybar
    ../modules/rofi
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
  ];
}
