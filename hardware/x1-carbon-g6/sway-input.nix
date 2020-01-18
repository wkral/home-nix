{pkgs, ... }:
{
  xdg.configFile."sway/config.d/x1c-g6-inputs".text = ''
input "1739:0:Synaptics_TM3289-021" {
    dwt enabled
    click_method clickfinger
    tap enabled
    drag disabled
    natural_scroll enabled
    middle_emulation disabled
    accel_profile adaptive
    drag_lock disabled
    pointer_accel 0.2
}

input "2:10:TPPS/2_Elan_TrackPoint" {
    dwt enabled
    accel_profile adaptive
}

input "1:1:AT_Translated_Set_2_keyboard" {
    xkb_capslock disabled
    xkb_options caps:escape
}

### Audio controls

bindsym XF86AudioRaiseVolume exec pactl set-sink-volume 0 +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume 0 -5%
bindsym XF86AudioMute exec pactl set-sink-mute 0 toggle
bindsym XF86AudioMicMute exec pactl set-source-mute 1 toggle
  '';
}
