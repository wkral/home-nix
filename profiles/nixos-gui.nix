{ pkgs, ... }:
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
    networkmanagerapplet
    font-manager
    zbar
    imv
    gnome3.eog
    pavucontrol
    pinentry_gnome
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  home.file.".Xresources".text = ''
    Xcursor.theme=Bibata_Ice
  '';
}
