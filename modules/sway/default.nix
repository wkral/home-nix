{pkgs, ...}:
{

  home.packages = with pkgs; [

  ];

  xdg.configFile."sway/config".text = ''
# Default config for sway
#
# Copy this to ~/.config/sway/config and edit it to your liking.
#
# Read `man 5 sway` for a complete reference.

### Variables
#
# Logo key. Use Mod1 for Alt.
set $mod Mod4
# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l
# Your preferred terminal emulator
set $term alacritty
# Your preferred application launcher
set $menu rofi -show drun

### Output configuration
#
output * bg ~/wallpapers/12878491_1600x1200.jpg fill

font Noto Sans Mono 9


exec ${pkgs.swayidle}/bin/swayidle \
    timeout 600 'swaylock' \
    timeout 565 'swaymsg "output * dpms off"' \
         resume 'swaymsg "output * dpms on"'

exec ${pkgs.kanshi}/bin/kanshi

exec chg-bg

### Key bindings
#
# Basics:
#
    # start a terminal
    bindsym $mod+Return exec $term

    # kill focused window
    bindsym $mod+Shift+q kill

    # start your launcher
    bindsym $mod+d exec $menu

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # reload the configuration file
    bindsym $mod+Shift+c reload

    # exit sway (logs you out of your wayland session)
    bindsym $mod+Shift+e exit
#
# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # _move_ the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspaces:
#
    set $wk1 1
    set $wk2 2
    set $wk3 3
    set $wk4 4
    set $wk5 5
    set $wk6 6
    set $wk7 7
    set $wk8 8
    set $wk9 9
    set $wk0 10
    # switch to workspace
    bindsym $mod+1 workspace $wk1
    bindsym $mod+2 workspace $wk2
    bindsym $mod+3 workspace $wk3
    bindsym $mod+4 workspace $wk4
    bindsym $mod+5 workspace $wk5
    bindsym $mod+6 workspace $wk6
    bindsym $mod+7 workspace $wk7
    bindsym $mod+8 workspace $wk8
    bindsym $mod+9 workspace $wk9
    bindsym $mod+0 workspace $wk0
    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $wk1
    bindsym $mod+Shift+2 move container to workspace $wk2
    bindsym $mod+Shift+3 move container to workspace $wk3
    bindsym $mod+Shift+4 move container to workspace $wk4
    bindsym $mod+Shift+5 move container to workspace $wk5
    bindsym $mod+Shift+6 move container to workspace $wk6
    bindsym $mod+Shift+7 move container to workspace $wk7
    bindsym $mod+Shift+8 move container to workspace $wk8
    bindsym $mod+Shift+9 move container to workspace $wk9
    bindsym $mod+Shift+0 move container to workspace $wk0
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.

    workspace $wk1 output eDP-1
    workspace $wk2 output eDP-1
    workspace $wk3 output eDP-1
    workspace $wk4 output eDP-1
    workspace $wk5 output eDP-1
    workspace $wk6 output eDP-1
    workspace $wk7 output eDP-1
    workspace $wk8 output HDMI-A-1
    workspace $wk9 output HDMI-A-1
    workspace $wk0 output HDMI-A-1
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10 px or 10 ppt
    bindsym $down resize grow height 10 px or 10 ppt
    bindsym $up resize shrink height 10 px or 10 ppt
    bindsym $right resize grow width 10 px or 10 ppt

    # ditto, with arrow keys
    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    # return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

bar {
    height 19
    position top
    swaybar_command ${pkgs.waybar}/bin/waybar
}

gaps inner 8
gaps outer -8
smart_gaps on

default_border none
focus_follows_mouse no

include config.d/*
'';
}