{pkgs, ... }:
{
  imports = [
    ./sway.nix
    ../modules/alacritty
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
    gnome3.networkmanagerapplet
    zbar
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
  };
}
