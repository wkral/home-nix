{ config, lib, ... }:
{

  options.wk.gui.niri =
    let
      workspaceType = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption {
            default = false;
          };
          monitor = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      };
    in
    {
      mapTouchOutput = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "eDP-1";
      };
      workspaces = {
        surf = lib.mkOption {
          type = workspaceType;
          default = {
            enable = true;
          };
        };
        work = lib.mkOption {
          type = workspaceType;
          default = {
            enable = false;
          };
        };
        chat = lib.mkOption {
          type = workspaceType;
          default = {
            enable = false;
          };
        };
      };
    };
  imports = [
    ./services.nix
  ];
  config =
    let
      cfg = config.wk.gui.niri;
      optStr = lib.strings.optionalString;
      openOutput = monitor: optStr (!isNull monitor) " { open-on-output \"${monitor}\"; }";
    in
    {
      xdg.configFile."niri/config.kdl".text = ''
        input {
            keyboard {
                xkb {
                    options "caps:escape"
                }
            }

            touchpad {
                tap
                dwt
                natural-scroll
            }

            mouse { }

            trackpoint { }

            ${optStr (!isNull cfg.mapTouchOutput) "input touch { map-to-output \"${cfg.mapTouchOutput}\"; }"}
        }

        layout {
            gaps 10

            center-focused-column "never"

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
                proportion 0.8
            }

            default-column-width { }

            focus-ring {
                width 3

                active-color "#bd93f9"
                inactive-color "#505050"
            }

            border {
                off
            }
        }

        prefer-no-csd

        screenshot-path "~/pictures/screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png"

        animations { }

        window-rule {
            match app-id=r#"firefox$"# title="^Picture-in-Picture$"
            open-floating true
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+Return { spawn "alacritty"; }
            Mod+D { spawn "wofi" "--show" "drun"; }
            Mod+grave { spawn "quickcmd"; }
            Super+Alt+L { spawn "swaylock"; }


            XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "3%+"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "3%-"; }
            XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

            XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

            Mod+Q { close-window; }

            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-down; }
            Mod+Up    { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+H     { focus-column-left; }
            Mod+L     { focus-column-right; }

            Mod+Shift+Left  { move-column-left; }
            Mod+Shift+Down  { move-window-down; }
            Mod+Shift+Up    { move-window-up; }
            Mod+Shift+Right { move-column-right; }
            Mod+Shift+H     { move-column-left; }
            Mod+Shift+J     { move-window-down; }
            Mod+Shift+K     { move-window-up; }
            Mod+Shift+L     { move-column-right; }

            Mod+J     { focus-window-or-workspace-down; }
            Mod+K     { focus-window-or-workspace-up; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End  { move-column-to-last; }

            Mod+Ctrl+Left  { focus-monitor-left; }
            Mod+Ctrl+Down  { focus-monitor-down; }
            Mod+Ctrl+Up    { focus-monitor-up; }
            Mod+Ctrl+Right { focus-monitor-right; }
            Mod+Ctrl+H     { focus-monitor-left; }
            Mod+Ctrl+J     { focus-monitor-down; }
            Mod+Ctrl+K     { focus-monitor-up; }
            Mod+Ctrl+L     { focus-monitor-right; }

            Mod+Shift+Ctrl+J { move-workspace-to-monitor-down; };
            Mod+Shift+Ctrl+K { move-workspace-to-monitor-up; };

            Mod+Page_Down      { focus-workspace-down; }
            Mod+Page_Up        { focus-workspace-up; }
            Mod+U              { focus-workspace-down; }
            Mod+I              { focus-workspace-up; }
            Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
            Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
            Mod+Ctrl+U         { move-column-to-workspace-down; }
            Mod+Ctrl+I         { move-column-to-workspace-up; }

            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up   { move-workspace-up; }
            Mod+Shift+U         { move-workspace-down; }
            Mod+Shift+I         { move-workspace-up; }

            Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }

            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+Comma  { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+C { center-column; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }

            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+V       { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            Mod+Shift+E { quit; }
            Ctrl+Alt+Delete { quit; }

            Mod+Shift+P { power-off-monitors; }

        }

        environment {
            DISPLAY ":0";
            QT_QPA_PLATFORM "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION "1";
        }

        window-rule {
            match is-active=true
            shadow {
                on
                softness 30
                spread 30
                offset x=0 y=10
                draw-behind-window true
                color "#11111170"
            }
        }

        window-rule {
            match is-floating=true
            shadow {
                on
                softness 20
                spread 10
                offset x=0 y=5
                draw-behind-window true
                color "#11111170"
            }
        }

        window-rule {
            match is-active=false
            opacity 0.95
        }

        window-rule {
            match app-id="gcr-prompter"
            block-out-from "screencast"
        }

        layer-rule {
            match namespace="^notifications$"
            block-out-from "screencast"

            shadow {
                on
                softness 20
                spread 0
                offset x=0 y=5
                draw-behind-window true
                color "#11111170"
            }
        }

        layer-rule {
            match namespace="^wofi$"

            shadow {
                on
                softness 20
                spread 10
                offset x=0 y=5
                draw-behind-window true
                color "#11111170"
            }
        }

      ''
      + optStr cfg.workspaces.surf.enable ''
        workspace "Surf"${openOutput cfg.workspaces.surf.monitor}

        window-rule {
            match at-startup=true app-id="firefox"
            open-on-workspace "Surf"
        }

        spawn-at-startup "firefox"

      ''
      + optStr cfg.workspaces.work.enable ''
        workspace "Work"${openOutput cfg.workspaces.work.monitor}

      ''
      + optStr cfg.workspaces.chat.enable ''
        workspace "Chat"${openOutput cfg.workspaces.chat.monitor}

        window-rule {
            match at-startup=true app-id="signal"
            open-on-workspace "Chat"
            open-maximized true
        }

        spawn-at-startup "signal-desktop"

      '';
    };
}
