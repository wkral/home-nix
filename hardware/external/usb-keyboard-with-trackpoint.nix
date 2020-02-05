{pkgs, ... }:
{
  xdg.configFile."sway/config.d/usb-keyboard-with-trackpoint".text = ''
input "6127:24647:Lenovo_ThinkPad_Compact_USB_Keyboard_with_TrackPoint" {
    dwt enabled
    accel_profile adaptive

    xkb_capslock disabled
    xkb_options caps:escape
}
  '';
}
